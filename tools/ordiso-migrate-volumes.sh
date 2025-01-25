#!/bin/bash

# Backup Docker volumes
docker run --rm --volumes-from ordiso-duplicati         -v $(pwd):/backup busybox tar cvfz /backup/ordiso-duplicati.tar.gz          /config
docker run --rm --volumes-from ordiso-vaultwarden       -v $(pwd):/backup busybox tar cvfz /backup/ordiso-vaultwarden.tar.gz        /data
docker run --rm --volumes-from ordiso-homepage          -v $(pwd):/backup busybox tar cvfz /backup/ordiso-homepage.tar.gz           /app/config
docker run --rm --volumes-from ordiso-dns-server        -v $(pwd):/backup busybox tar cvfz /backup/ordiso-dns-server.tar.gz         /etc/bind /var/cache/bind /var/lib/bind
docker run --rm --volumes-from ordiso-authelia          -v $(pwd):/backup busybox tar cvfz /backup/ordiso-authelia.tar.gz           /config
docker run --rm --volumes-from ordiso_pypi_server       -v $(pwd):/backup busybox tar cvfz /backup/ordiso-pypi-server.tar.gz        /data/packages
docker run --rm --volumes-from ordiso_nginx_manager     -v $(pwd):/backup busybox tar cvfz /backup/ordiso-nginx-manager.tar.gz      /data /etc/letsencrypt /snippets
docker run --rm --volumes-from ordiso_db_postgres       -v $(pwd):/backup busybox tar cvfz /backup/ordiso-db-postgres.tar.gz        /var/lib/postgresql/data
docker run --rm --volumes-from ordiso_db_mysql          -v $(pwd):/backup busybox tar cvfz /backup/ordiso-db-mysql.tar.gz           /docker-entrypoint-initdb.d /var/lib/mysql
