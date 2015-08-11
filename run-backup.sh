#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONTAINER_NAME=$1

docker run --rm -v $DIR:/backup --link $CONTAINER_NAME:mongo mongobackup no-cron
