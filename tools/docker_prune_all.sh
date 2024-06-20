#!/bin/bash

# Stop all
docker stop $(docker ps -a -q)

# Prune all  
docker system prune -a

# Get all
docker container ls
docker volume ls
docker network ls
docker image ls