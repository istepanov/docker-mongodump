#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
DIR="/backup"
FILE="$DIR/$DATE.tar.gz"

mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --archive=$FILE --gzip

if [[ $BACKUP_EXPIRE_DAYS ]]; then
    echo "Removing backups older than $BACKUP_EXPIRE_DAYS days"
    find $DIR -mtime +$BACKUP_EXPIRE_DAYS -type f -delete
fi

echo "Job finished: $(date)"
