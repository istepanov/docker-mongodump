#!/bin/bash

set -e

echo "$(date +%Y-%m-%d:%H:%M:%S) job started"

DATE=$(date +%Y%m%d_%H%M%S)
DIR="/backup"

if [[ $BACKUP_FILE_NAME ]]; then
    FILE="$DIR/$BACKUP_FILE_NAME"
else
    FILE="$DIR/$DATE"
fi

command="mongodump --host $MONGO_HOST --port $MONGO_PORT --gzip"

if [[ $MONGO_USERNAME ]]; then
    command+=" -u $MONGO_USERNAME"

    if [[ $MONGO_PASSWORD ]]; then
        command+=" -p $MONGO_PASSWORD"
    fi
fi

# All output of mongodump is stderr, therefore filter the errors manually.
filter_errors="2> >(grep -i 'failed\|error')"

if [[ $MONGO_DB_NAMES ]]; then
    dbs=( $MONGO_DB_NAMES )
    filename=$FILE

    for d in ${dbs[@]}
    do
        if [[ ! $BACKUP_FILE_NAME ]]; then
            filename="$FILE-$d.gz"
        fi
        eval $command --archive=$filename -d $d $filter_errors
        echo "$(date +%Y-%m-%d:%H:%M:%S) dumped database: $filename"
    done
else
    eval $command --archive="$FILE.gz" $filter_errors
    echo "$(date +%Y-%m-%d:%H:%M:%S) dumped all databases: $FILE"
fi

if [[ $BACKUP_EXPIRE_DAYS ]]; then
    find $DIR -mtime +$BACKUP_EXPIRE_DAYS -type f -delete
    echo "$(date +%Y-%m-%d:%H:%M:%S) removed backups older than $BACKUP_EXPIRE_DAYS days"
fi

printf "$(date +%Y-%m-%d:%H:%M:%S) job finished\n\n"
