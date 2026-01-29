FROM mysql:8.0

# Copiar configuração personalizada
COPY configs/mysql/my.cnf /etc/mysql/conf.d/

# Copiar script de inicialização
COPY scripts/init-db.sql /docker-entrypoint-initdb.d/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD} || exit 1

EXPOSE 3306