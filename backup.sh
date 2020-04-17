#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/backup/backup-$DATE.tar.gz"

mkdir -p dump
mongodump --uri "$MONGO_URI"
tar -zcvf "$FILE" dump/
rm -rf dump/

if [[ "$TARGET_S3_FOLDER" ]]; then
    aws s3 cp "$FILE" "$TARGET_S3_FOLDER"
    echo "$FILE uploaded to $TARGET_S3_FOLDER"
    rm -rf "$FILE"
fi

echo "Job finished: $(date)"
