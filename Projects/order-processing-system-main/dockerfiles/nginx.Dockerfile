FROM nginx:alpine

# Remover configuração padrão
RUN rm /etc/nginx/conf.d/default.conf

# Copiar configurações
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template

# Script de inicialização
COPY configs/nginx/start.sh /start.sh
RUN chmod +x /start.sh

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

EXPOSE 80
CMD ["/start.sh"]