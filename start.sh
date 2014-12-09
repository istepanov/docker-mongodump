#!/bin/bash

echo "0 12 * * * /backup.sh" | crontab -
exec cron -f
