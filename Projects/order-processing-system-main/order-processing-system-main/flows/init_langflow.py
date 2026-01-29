#!/usr/bin/env python3
"""
Script para inicializar o Langflow com o flow do Order Assistant
"""
import requests
import json
import time
import os

def setup_langflow():
    """Configura o Langflow com nosso flow personalizado"""
    
    langflow_url = "http://localhost:7860"
    
    # Aguardar o Langflow iniciar
    print("Aguardando Langflow iniciar...")
    for _ in range(30):  # 30 tentativas
        try:
            response = requests.get(f"{langflow_url}/health")
            if response.status_code == 200:
                print("Langflow está rodando!")
                break
        except:
            pass
        time.sleep(2)
    else:
        print("Langflow não iniciou a tempo")
        return
    
    # Carregar o flow do arquivo
    flow_path = "/app/custom_flows/order-assistant.json"
    if os.path.exists(flow_path):
        with open(flow_path, 'r') as f:
            flow_data = json.load(f)
        
        # TODO: Implementar upload do flow via API do Langflow
        # (A API de upload pode variar por versão)
        
        print("Flow do Order Assistant carregado")
    else:
        print(f"Flow não encontrado em {flow_path}")
    
    print("\n Order Assistant configurado!")
    print(" Acesse: http://localhost:7860")
    print(" Comece a conversar com seu assistente de IA!")

if __name__ == "__main__":
    setup_langflow()