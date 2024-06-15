#!/bin/bash

echo "Starting server setup..."

# Get the path of this script independent of where it is called from
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Update system packages
sudo apt update

# # Install required tools
sudo apt install -y make \
    docker \
    docker-compose \
    postgresql \
    postgresql-common \
    python3-sphinx


# Create temporary directory tree for the database backup
mkdir -p ./tmp/backups/ordiso.db
mkdir -p ./tmp/backups/ordiso.superset

# If fresh installation, download the newest version of the database backups
# python3 ./storage/main.py
python3 ${SCRIPT_PATH}/storage/main.py initialize --config_file ${SCRIPT_PATH}/docker/backup_conf.json --output_folder ${SCRIPT_PATH}

# Pull Docker images
sudo docker-compose pull

# Start Docker containers. If the containers are already running, this command will restart them.
sudo docker-compose up -d

# # Additional setup steps
# # ...

# # Print success message
# echo "Server setup completed successfully!"


# Install periodic tasks using cron jobs to automate the backup process
# crontab -l | { cat; echo "*/1 * * * * python3 ${SCRIPT_PATH}/cron/backup_manager.py"; } | crontab -
# crontab -l | { cat; echo "*/1 * * * * python3 ${SCRIPT_PATH}/storage/main.py"; } | crontab -
