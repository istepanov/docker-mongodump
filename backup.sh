#!/bin/bash

set -e

echo "Job started: $(date)"

echo "deleting files older than 30 days"
find /backup -mtime +30 -type f -delete

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/$MONGO_DB_NAME-backup-$DATE.tar.gz"

mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db=$MONGO_DB_NAME
tar -zcvf $FILE dump/
rm -rf dump/

echo "Job finished: $(date)"
