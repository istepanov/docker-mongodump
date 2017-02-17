#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"
OUTPUT="dump/"

mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT -o $OUTPUT
tar -zcvf $FILE $OUTPUT
rm -rf $OUTPUT

echo "Job finished: $(date)"
