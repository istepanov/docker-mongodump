#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONTAINER_NAME=$1
DOCKER_NAME="istepanov/mongodump"

docker run --rm -v $DIR:/backup --link $CONTAINER_NAME:mongo $DOCKER_NAME no-cron
