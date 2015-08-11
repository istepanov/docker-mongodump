#!/bin/bash

set -e

env > /tmp/mongodump_env

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    cp /crontab /etc/cron.d/mongobackup-cron
    exec cron -f
fi
