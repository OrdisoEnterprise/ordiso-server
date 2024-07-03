docker run --rm --volumes-from ordiso_db_mysql -v /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-mysql-data:/backup ubuntu tar cvf /backup/backup.tar /var/lib/mysql
tar -xvf /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-mysql-data/backup.tar -C /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-mysql-data


docker run --rm --volumes-from ordiso_db_postgres -v /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-postgres-data:/backup ubuntu tar cvf /backup/backup.tar /var/lib/postgresql
tar -xvf /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-postgres-data/backup.tar -C /home/ordiso/Ordiso-Server/data/volumes/ordiso-db-postgres-data


docker run --rm --volumes-from ordiso_pypi_server -v /home/ordiso/Ordiso-Server/data/volumes/ordiso-pypi-server-data:/backup ubuntu tar cvf /backup/backup.tar /data/packages
tar -xvf /home/ordiso/Ordiso-Server/data/volumes/ordiso-pypi-server-data/backup.tar -C /home/ordiso/Ordiso-Server/data/volumes/ordiso-pypi-server-data


docker run --rm --volumes-from ordiso_superset_app -v /home/ordiso/Ordiso-Server/data/volumes/ordiso-superset-data:/backup ubuntu tar cvf /backup/backup.tar /app/docker /app/superset_home
tar -xvf /home/ordiso/Ordiso-Server/data/volumes/ordiso-superset-data/backup.tar -C /home/ordiso/Ordiso-Server/data/volumes/ordiso-superset-data