#!/bin/bash

set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    echo "$CRON_SCHEDULE /backup.sh" | crontab -
    exec cron -f
fi
