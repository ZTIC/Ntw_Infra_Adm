import requests
import json
from typing import Optional, Dict, Any

class OrderSystemTools:
    """Ferramentas customizadas para o sistema de pedidos"""
    
    def __init__(self, api_base_url: str = "http://app:3000"):
        self.api_base_url = api_base_url
    
    def get_order_stats(self) -> str:
        """Obtém estatísticas do sistema de pedidos"""
        try:
            response = requests.get(f"{self.api_base_url}/api/stats", timeout=5)
            if response.status_code == 200:
                stats = response.json()
                return self._format_stats(stats)
            return "Não foi possível obter estatísticas"
        except Exception as e:
            return f"Erro ao obter estatísticas: {str(e)}"
    
    def get_order_by_id(self, order_id: str) -> str:
        """Busca um pedido pelo ID"""
        try:
            response = requests.get(f"{self.api_base_url}/api/orders/{order_id}", timeout=5)
            if response.status_code == 200:
                order = response.json()
                return self._format_order(order)
            return f"Pedido {order_id} não encontrado"
        except Exception as e:
            return f"Erro ao buscar pedido: {str(e)}"
    
    def get_recent_orders(self, limit: int = 10) -> str:
        """Lista os pedidos mais recentes"""
        try:
            response = requests.get(f"{self.api_base_url}/api/orders", timeout=5)
            if response.status_code == 200:
                orders = response.json()
                recent_orders = orders[:limit] if isinstance(orders, list) else []
                return self._format_orders_list(recent_orders)
            return "Não foi possível listar os pedidos"
        except Exception as e:
            return f"Erro ao listar pedidos: {str(e)}"
    
    def check_system_health(self) -> str:
        """Verifica a saúde do sistema"""
        try:
            response = requests.get(f"{self.api_base_url}/health", timeout=5)
            if response.status_code == 200:
                health = response.json()
                return self._format_health(health)
            return "Sistema não responde"
        except Exception as e:
            return f"Erro ao verificar saúde: {str(e)}"
    
    def create_order_example(self) -> str:
        """Retorna exemplo de como criar um pedido"""
        example = {
            "customer_email": "cliente@exemplo.com",
            "items": [
                {
                    "product_id": "PROD001",
                    "name": "Produto A",
                    "price": 29.99,
                    "quantity": 2
                }
            ],
            "shipping_address": "Rua Exemplo, 123, Lisboa"
        }
        
        curl_command = f"""curl -X POST {self.api_base_url}/api/orders \\
  -H "Content-Type: application/json" \\
  -d '{json.dumps(example, indent=2)}'"""
        
        return f"**Exemplo de criação de pedido:**\n```bash\n{curl_command}\n```"
    
    def _format_stats(self, stats: Dict[str, Any]) -> str:
        """Formata estatísticas para exibição"""
        return f"""📊 **Estatísticas do Sistema:**
        
• **Total de Pedidos:** {stats.get('total_orders', 0)}
• **Receita Total:** €{stats.get('total_revenue', 0):.2f}
• **Pedidos Hoje:** {stats.get('today_orders', 0)}
• **Distribuição por Status:**
{json.dumps(stats.get('status_distribution', {}), indent=2, ensure_ascii=False)}"""
    
    def _format_order(self, order: Dict[str, Any]) -> str:
        """Formata um pedido para exibição"""
        items = json.loads(order['items']) if isinstance(order['items'], str) else order['items']
        items_text = "\n".join([f"  • {item['name']} (x{item['quantity']}) - €{item['price']}" for item in items])
        
        return f"""📦 **Pedido {order['order_id']}:**
        
• **Cliente:** {order['customer_email']}
• **Total:** €{order['total_amount']}
• **Status:** {order['status']}
• **Endereço:** {order['shipping_address']}
• **Itens:**
{items_text}
• **Criado em:** {order['created_at']}
• **Atualizado em:** {order.get('updated_at', 'N/A')}"""
    
    def _format_orders_list(self, orders: list) -> str:
        """Formata lista de pedidos"""
        if not orders:
            return "Nenhum pedido encontrado"
        
        text = "📋 **Pedidos Recentes:**\n\n"
        for order in orders:
            text += f"• **{order['order_id']}** - {order['customer_email']} - €{order['total_amount']} - {order['status']}\n"
        
        return text
    
    def _format_health(self, health: Dict[str, Any]) -> str:
        """Formata status de saúde do sistema"""
        checks = health.get('checks', {})
        return f"""🏥 **Status do Sistema:** {health.get('status', 'unknown')}
        
• **API:** {'✅' if checks.get('service', False) else '❌'}
• **Database:** {'✅' if checks.get('database', False) else '❌'}
• **Event Hub:** {'✅' if checks.get('eventhub', False) else '⚠️ Não configurado'}
• **Última verificação:** {health.get('timestamp', 'N/A')}"""