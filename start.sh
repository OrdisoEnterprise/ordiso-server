#!/bin/bash

# Get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Current directory: ${DIR}"

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: Docker is not installed.' >&2
  exit 1
fi

# Initialize Docker Compose files
echo "Initializing Traefik..."
docker compose -f ${DIR}/services/ordiso-traefik/docker-compose.yml up -d

echo "Initializing DDClient..."
docker compose -f ${DIR}/services/ordiso-ddclient/docker-compose.yml up -d

echo "Initializing Databases..."
docker compose -f ${DIR}/services/ordiso-db-postgres/docker-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-db-mysql/docker-compose.yml up -d

echo "Initializing Critical Components..."
docker compose -f ${DIR}/services/ordiso-authelia/docker-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-watchtower/docker-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-duplicati/docker-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-vaultwarden/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-wazuh/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-dns-server/docker-compose.yml up -d

# echo "Initializing Monitoring Components..."
# docker compose -f ${DIR}/services/ordiso-frometheus/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-grafana/docker-compose.yml up -d

echo "Initializing Other..."
docker compose -f ${DIR}/services/ordiso-homepage/docker-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-pypi-server/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-nextcloud/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-node-red/docker-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-superset/docker-compose.yml up -d

echo "All Docker Compose files have been launched."