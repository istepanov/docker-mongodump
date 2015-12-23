#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"

arr=("--quiet" "-h" "$MONGO_PORT_27017_TCP_ADDR" "-p" "$MONGO_PORT_27017_TCP_PORT")
if [ ! -z $MONGO_DB_NAME ]; then
  arr+=("-d")
  arr+=("$MONGO_DB_NAME")
fi
mongodump "${arr[@]}"
tar -zcvf $FILE dump/
rm -rf dump/

echo "Job finished: $(date)"
