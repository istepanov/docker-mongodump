#!/bin/bash

env > /tmp/mongodump_env

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

echo "$CRON_SCHEDULE /backup.sh" | crontab -
exec cron -f
