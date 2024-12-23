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
docker compose -f ${DIR}/services/ordiso-traefik/services-compose.yml up -d

echo "Initializing DDClient..."
docker compose -f ${DIR}/services/ordiso-ddclient/services-compose.yml up -d

echo "Initializing Databases..."
docker compose -f ${DIR}/services/ordiso-db-postgres/services-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-db-mysql/services-compose.yml up -d

echo "Initializing Critical Components..."
docker compose -f ${DIR}/services/ordiso-authelia/services-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-watchtower/services-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-duplicati/services-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-vaultwarden/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-wazuh/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-dns-server/services-compose.yml up -d

# echo "Initializing Monitoring Components..."
# docker compose -f ${DIR}/services/ordiso-frometheus/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-grafana/services-compose.yml up -d

echo "Initializing Other..."
docker compose -f ${DIR}/services/ordiso-homepage/services-compose.yml up -d
docker compose -f ${DIR}/services/ordiso-pypi-server/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-nextcloud/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-node-red/services-compose.yml up -d
# docker compose -f ${DIR}/services/ordiso-superset/services-compose.yml up -d

echo "All Docker Compose files have been launched."