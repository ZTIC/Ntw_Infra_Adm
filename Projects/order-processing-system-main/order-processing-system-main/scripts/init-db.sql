-- Criar banco de dados
CREATE DATABASE IF NOT EXISTS order_management;
USE order_management;

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de pedidos
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) UNIQUE NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    items JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- Inserir dados de exemplo
INSERT IGNORE INTO customers (email, name, phone, address) VALUES
('john.doe@example.com', 'John Doe', '+1-555-0100', '123 Main St, New York'),
('jane.smith@example.com', 'Jane Smith', '+1-555-0101', '456 Oak Ave, Los Angeles');

INSERT IGNORE INTO orders (order_id, customer_email, total_amount, status, shipping_address, items) VALUES
('ORD-2024-001', 'john.doe@example.com', 99.99, 'delivered', '123 Main St, New York',
 '[{"name": "Laptop", "price": 99.99, "quantity": 1}]'),
('ORD-2024-002', 'jane.smith@example.com', 149.98, 'processing', '456 Oak Ave, Los Angeles',
 '[{"name": "Mouse", "price": 29.99, "quantity": 2}, {"name": "Keyboard", "price": 89.99, "quantity": 1}]');