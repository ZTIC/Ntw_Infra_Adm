FROM traefik:v3.0

# Copiar configuração
COPY configs/traefik/traefik.yml /etc/traefik/traefik.yml

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1

EXPOSE 80 8080