#!/bin/sh

# Substituir variáveis de ambiente nos templates
envsubst '${SERVER_NAME} ${UPSTREAM_SERVICE} ${UPSTREAM_PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
envsubst '${UPSTREAM_SERVICE} ${UPSTREAM_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Iniciar Nginx
exec nginx -g 'daemon off;'