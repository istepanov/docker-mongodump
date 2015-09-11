istepanov/mongodump
===================

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
