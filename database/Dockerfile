FROM mysql:8.0.34

# Configurações do banco de dados
ENV MYSQL_DATABASE radius
ENV MYSQL_ROOT_PASSWORD radiusrootpwd

# Copy the database schema to the /docker-entrypoint-initdb.d directory
COPY database/setup.sql /docker-entrypoint-initdb.d/


