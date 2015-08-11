#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BACKUP_DIR=/var/backups/mongodb
CONTAINER_NAME=$1
DOCKER_NAME="istepanov/mongodump"

docker run --rm -v $BACKUP_DIR:/backup --link $CONTAINER_NAME:mongo $DOCKER_NAME no-cron
