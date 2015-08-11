#!/bin/bash
BACKUP_DIR=/var/backups/mongodb
CONTAINER_NAME=$1
DOCKER_NAME="istepanov/mongodump"

docker run -d --name mongodump_$CONTAINER_NAME -v $BACKUP_DIR:/backup -e 'CRON_SCHEDULE=* * * * *' --link $CONTAINER_NAME:mongo $DOCKER_NAME
