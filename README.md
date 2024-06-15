# Build the docker image
docker build -t ordiso-mysql .

# Run the docker container
docker run -d -p 3306:3306 --privileged -it --name ordiso-mysql ordiso-mysql /usr/sbin/init

# Entry into the docker container 
docker exec -it  ordiso-mysql /bin/bash

# Check the logs
docker logs ordiso-mysql

# Connect to the mysql server
docker exec -it ordiso-mysql mysql -uroot -proot ordiso-db

# Show the tables
SHOW TABLES;

# Show the data
SELECT * FROM finances;

# Exit the mysql server
exit  list[Backup]