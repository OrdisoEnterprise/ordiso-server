#!/bin/bash

# Prune all  
docker system prune -a

# Prune Docker containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Prune Docker volumes
docker volume rm $(docker volume ls -q)

# Prune Docker networks
docker network rm $(docker network ls -q)

# Prune Docker images
# docker rmi $(docker images -a -q)
# docker image prune -a -f

# Get all
docker container ls
docker volume ls
docker network ls
docker image ls