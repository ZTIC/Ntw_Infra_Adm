FROM nginx:alpine

# Instalar gettext para envsubst
RUN apk add --no-cache gettext

# Copiar template
COPY configs/nginx/nginx.conf.template /etc/nginx/nginx.conf.template

# Script de inicialização
COPY <<'EOF' /start.sh
#!/bin/sh
envsubst '${SERVER_NAME} ${UPSTREAM_SERVICE} ${UPSTREAM_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -g 'daemon off;'
EOF

RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]