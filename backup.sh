#!/bin/bash

set -eo pipefail

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

if [[ -z "$TARGET_FOLDER" ]]; then
    # dump directly to AWS S3

    if [[ -z "$TARGET_S3_FOLDER" ]]; then
        >&2 echo "If TARGET_FOLDER is null/unset, TARGET_S3_FOLDER must be set"
        exit 1
    fi

    mongodump --uri "$MONGO_URI" --gzip --archive | aws s3 cp - "${TARGET_S3_FOLDER%/}/backup-$DATE.tar.gz"
    echo "Mongo dump uploaded to $TARGET_S3_FOLDER"
else
    # save dump locally (and optionally to AWS S3)

    FILE="$TARGET_FOLDER/backup-$DATE.tar.gz"

    mkdir -p "$TARGET_FOLDER"
    mongodump --uri "$MONGO_URI" --gzip --archive="$FILE"
    echo "Mongo dump saved to $FILE"

    if [[ -n "$TARGET_S3_FOLDER" ]]; then
        aws s3 cp "$FILE" "$TARGET_S3_FOLDER"
        echo "$FILE uploaded to $TARGET_S3_FOLDER"
    fi
fi

echo "Job finished: $(date)"
