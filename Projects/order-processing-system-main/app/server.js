const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const { EventHubProducerClient } = require('@azure/event-hubs');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'mysql',
  port: process.env.DB_PORT || 3306,
  database: process.env.DB_NAME || 'order_management',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root123',
  waitForConnections: true,
  connectionLimit: 10
});


// Inicializar Event Hub se configurado
let eventHubProducer = null;
if (process.env.EVENTHUB_CONNECTION_STRING) {
  try {
      eventHubProducer = new EventHubProducerClient(
      process.env.EVENTHUB_CONNECTION_STRING,
      process.env.EVENTHUB_NAME
    );
    console.log('Event Hub Producer initialized');
  } catch (error) {
    console.error('Error initializing Event Hub:', error.message);
  }
}

// Health check
app.get('/health', async (req, res) => {
  const checks = {
    database: false,
    eventhub: false,
    service: true
  };
  
  try {
    await pool.query('SELECT 1');
    checks.database = true;
  } catch (error) {
    console.error('Database health check failed:', error.message);
  }
  
  checks.eventhub = !!eventHubProducer;
  
  res.json({
    status: checks.database ? 'healthy' : 'degraded',
    service: 'order-processing-system',
    timestamp: new Date().toISOString(),
    checks
  });
});

// Home page
app.get('/', (req, res) => {
  res.json({
    message: 'Order Processing System API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      orders: '/api/orders',
      orderById: '/api/orders/:id',
      stats: '/api/stats'
    },
    features: {
      eventhub: !!eventHubProducer,
      database: true
    }
  });
});

// Get all orders
app.get('/api/orders', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM orders ORDER BY created_at DESC LIMIT 50');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create new order
app.post('/api/orders', async (req, res) => {
  try {
    const { customer_email, items, shipping_address } = req.body;
    
    // Validar entrada
    if (!customer_email || !items || !shipping_address) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    // Validar formato dos items
    if (!Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ error: 'Items must be a non-empty array' });
    }
    
    // Gerar ID do pedido
    const order_id = `ORD-${Date.now()}-${Math.random().toString(36).substr(2, 6).toUpperCase()}`;
    
    // Calcular total
    const total_amount = items.reduce((sum, item) => {
      return sum + (item.price * item.quantity);
    }, 0);
    
    // Inserir no banco
    const [result] = await pool.query(
      `INSERT INTO orders (order_id, customer_email, items, total_amount, shipping_address, status) 
       VALUES (?, ?, ?, ?, ?, 'pending')`,
      [order_id, customer_email, JSON.stringify(items), total_amount, shipping_address]
    );
    
    const orderData = {
      id: result.insertId,
      order_id,
      customer_email,
      items,
      total_amount,
      shipping_address,
      status: 'pending',
      created_at: new Date().toISOString()
    };
    
    // Enviar evento para Event Hub se configurado
    if (eventHubProducer) {
      const eventData = {
        event_type: 'order_created',
        order_id: order_id,
        customer_email: customer_email,
        total_amount: total_amount,
        item_count: items.length,
        timestamp: new Date().toISOString(),
        metadata: {
          source: 'order-processing-api',
          version: '1.0'
        }
      };
      
      try {
        const batch = await eventHubProducer.createBatch();
        batch.tryAdd({ body: eventData });
        await eventHubProducer.sendBatch(batch);
        console.log(`Event sent to Event Hub for order: ${order_id}`);
      } catch (eventError) {
        console.error('Error sending to Event Hub:', eventError.message);
        // Não falhar a criação do pedido se o Event Hub falhar
      }
    }
    
    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      order: orderData
    });
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get order by ID
app.get('/api/orders/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM orders WHERE order_id = ?',
      [req.params.id]
    );
    
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get statistics
app.get('/api/stats', async (req, res) => {
  try {
    const [orders] = await pool.query('SELECT COUNT(*) as total FROM orders');
    const [revenue] = await pool.query('SELECT COALESCE(SUM(total_amount), 0) as revenue FROM orders');
    const [today] = await pool.query("SELECT COUNT(*) as today FROM orders WHERE DATE(created_at) = CURDATE()");
    const [status] = await pool.query("SELECT status, COUNT(*) as count FROM orders GROUP BY status");
    
    res.json({
      total_orders: orders[0].total,
      total_revenue: revenue[0].revenue,
      today_orders: today[0].today,
      status_distribution: status.reduce((acc, row) => {
        acc[row.status] = row.count;
        return acc;
      }, {})
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update order status
app.patch('/api/orders/:id/status', async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
    }
    
    const [result] = await pool.query(
      'UPDATE orders SET status = ? WHERE order_id = ?',
      [status, req.params.id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Order not found' });
    }
    
    res.json({
      success: true,
      message: `Order status updated to ${status}`,
      order_id: req.params.id,
      status
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health: http://localhost:${PORT}/health`);
  console.log(`Database: ${process.env.DB_HOST || 'mysql'}:${process.env.DB_PORT || 3306}`);
  console.log(`Event Hub: ${eventHubProducer ? 'Enabled' : 'Disabled'}`);
});