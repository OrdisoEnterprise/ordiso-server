# Create me a docker file to start a mysql server and restore data on initialization from a backup folder

# Use the official mysql image
FROM mysql:8

# Set the environment variables
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=ordiso-db

# Copy the backup folder to the docker container
# COPY ./backup /docker-entrypoint-initdb.d

RUN microdnf update && microdnf -y install \
    nano \
    vi \
    python3 \
    cronie 

COPY ./tools /app/tools
RUN chmod +x /app/tools/setup.sh && /app/tools/setup.sh

# Expose the port
EXPOSE 3306

# Run the mysql server
CMD ["mysqld"]