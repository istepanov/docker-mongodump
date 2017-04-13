istepanov/mongodump
===================

[![Build Status](https://travis-ci.org/istepanov/docker-mongodump.svg?branch=master)](https://travis-ci.org/istepanov/docker-mongodump)

Docker image with mongodump running as a cron task

### Usage

Attach a target mongo container to this container and mount a volume to container's `/data` folder. Backups will appear in this volume. Optionally set up cron job schedule (default is `0 1 * * *` - runs every day at 1:00 am).

    docker run -d \
        -v /path/to/target/folder:/backup \ # where to put backups
        -e 'CRON_SCHEDULE=0 1 * * *' \      # cron job schedule
        --link my-mongo-container:mongo \   # linked container with running mongo
        istepanov/mongodump

To run backup once without cron job, add `no-cron` parameter:

    docker run --rm \
        -v /path/to/target/folder:/backup \ # where to put backups
        --link my-mongo-container:mongo \   # linked container with running mongo
        istepanov/mongodump no-cron

#### Docker Compose example:

    version: '3'

    services:
      mongo:
        image: "mongo:3.4"

      mongo-backup:
        image: "istepanov/mongodump:3.4"
        volumes:
          - mongo-backup:/backup
        environment:
          CRON_SCHEDULE: '0 1 * * *'
        depends_on:
          - mongo

    volumes:
      mongo-backup:

#### Environment variables:

* `CRON_SCHEDULE` - cron schedule (default is `0 1 * * *`)
* `MONGO_HOST` - Mongo server hostname (default is `mongo`)
* `MONGO_PORT` - Mongo server port (default is `27017`)
