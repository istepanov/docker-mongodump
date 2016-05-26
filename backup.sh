#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"
OUTPUT="dump/"

mongodump --quiet --host $MONGODB_HOST:$MONGODB_PORT --out $OUTPUT
tar -zcvf $FILE $OUTPUT
rm -rf $OUTPUT

echo "Job finished: $(date)"
