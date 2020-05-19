#!/bin/bash

set -e

# Defaults
MONGO_HOST=${MONGO_HOST:-localhost}
MONGO_PORT=${MONGO_PORT:-27017}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 0 * * *}

# General environment
ENV=(
    "MONGO_HOST='$MONGO_HOST'"
    "MONGO_PORT='$MONGO_PORT'"
    "MONGO_USERNAME='$MONGO_USERNAME'"
    "MONGO_PASSWORD='$MONGO_PASSWORD'"
    "BACKUP_EXPIRE_DAYS='$BACKUP_EXPIRE_DAYS'"
    "MONGO_DB_NAMES='$MONGO_DB_NAMES'"
    "BACKUP_FILE_NAME='$BACKUP_FILE_NAME'"
)

function joinEnv {
    printf "$1%s" "${ENV[@]}"
}

if [[ "$1" == 'no-cron' ]]; then
    eval $(joinEnv " ") ./backup.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    echo -e "$(joinEnv "\n")\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi
