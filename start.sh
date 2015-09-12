#!/bin/bash

set -e

env > /tmp/mongodump_env

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    touch /var/log/cron.log
    echo "$CRON_SCHEDULE /backup.sh >> /var/log/cron.log 2>&1"
    echo "$CRON_SCHEDULE /backup.sh >> /var/log/cron.log 2>&1" | crontab -
    cron
    tail -f /var/log/cron.log
fi
