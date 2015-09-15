#!/bin/bash

set -e

env > /tmp/mongodump_env

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    echo "$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1"
    echo "$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    cron
    tail -f "$LOGFIFO"
fi
