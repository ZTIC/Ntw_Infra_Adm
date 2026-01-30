FROM mysql:8.0

# Copiar configuração personalizada
COPY configs/mysql/my.cnf /etc/mysql/conf.d/

# Copiar script de inicialização
COPY scripts/init-db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306