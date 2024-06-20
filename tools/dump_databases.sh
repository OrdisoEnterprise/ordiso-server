#!/bin/bash

ROOT=$(pwd)
DATE=`date +%Y-%m-%d"_"%H_%M_%S`

echo "Dumping databases..." > ordiso.log

# export PGPASSWORD=superset
# export MYSQL_PWD=dwe62a8evc_82
# MYSQL_PWD=dwe62a8evc_82

# # Dump postgresql databases
# DUMP_POSTGRES_OUTPUT=$ROOT/../tmp/backups/ordiso.superset/dump_superset_pg_$DATE.sql
# pg_dumpall -U superset -h localhost -p 54320 > $DUMP_POSTGRES_OUTPUT
# python3 $ROOT/backupManager/cli.py backup dump_superset_pg $ROOT/../docker/backup_conf.json $DUMP_POSTGRES_OUTPUT

# # Dump mysql databases
# DUMP_MYSQL_OUTPUT=$ROOT/../tmp/backups/ordiso.db/dump_ordiso_mysql_$DATE.sql
# mysqldump -uroot -h127.0.0.1 -P33050 -p$MYSQL_PWD --all-databases > $DUMP_MYSQL_OUTPUT
# python3 $ROOT/backupManager/cli.py backup dump_ordiso_mysql $ROOT/../docker/backup_conf.json $DUMP_MYSQL_OUTPUT

