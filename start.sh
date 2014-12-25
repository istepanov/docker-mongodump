#!/bin/bash

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

echo "$CRON_SCHEDULE /backup.sh" | crontab -
exec cron -f
