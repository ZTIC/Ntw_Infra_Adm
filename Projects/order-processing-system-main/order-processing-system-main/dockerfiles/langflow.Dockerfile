FROM langflowai/langflow:latest

# Criar diretório para flows personalizados
RUN mkdir -p /app/custom_flows

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:7860 || exit 1

EXPOSE 7860