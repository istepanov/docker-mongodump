# tenorok/mongodumper

Docker image with mongodump running as a cron task.

## Usage

Attach a target mongo container to this container and mount a volume to container `/backup` folder. The backups will appear in this volume as gzip-archives with names like `20170218_025718`, where mask is `%Y%m%d_%H%M%S`.

**Important**: This container should be in the same [network](https://docs.docker.com/engine/reference/commandline/network_connect/) as the mongodb container.

### Scheduled backups

```bash
docker run -d \
    -v /path/to/my-folder:/backup \ # path to put backups
    --network=my-network \          # connect container to the network with mongodb
    tenorok/mongodumper
```

### Manual backup

To run manual backup without cron job, add `no-cron` parameter.

```bash
docker run --rm \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    tenorok/mongodumper no-cron     # manual start
```

### Restore from backup

```
mongorestore --gzip --archive=/path/to/my-folder/20170218_025718
```

### Options `MONGO_HOST` and `MONGO_PORT`

Default host is `localhost`.

Default port is `27017`.

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'MONGO_HOST=my-mongo-host' \
    -e 'MONGO_PORT=4444' \
    tenorok/mongodumper
```

### Options `MONGO_USERNAME` and `MONGO_PASSWORD`

If your mongodb need user and password to access, you need set them in your environment.

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'MONGO_USERNAME=root' \          # mongo -u $MONGO_USERNAME
    -e 'MONGO_PASSWORD=rootpassword' \  # mongo -p $MONGO_PASSWORD
    tenorok/mongodumper
```

### Option `CRON_SCHEDULE`

For customize backups schedule.

Default schedule is `0 0 * * *` — runs every day at 00:00.

Recommend useful [online helper](https://crontab.guru/#0_3_*/5_*_*) for decoding crontab.

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'CRON_SCHEDULE=0 3 */5 * *' \    # custom cron job schedule
    tenorok/mongodumper
```

### Option `BACKUP_EXPIRE_DAYS`

For remove unnecessary archives older than specified number of days.

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'BACKUP_EXPIRE_DAYS=30' \        # number of days for remove old backups
    tenorok/mongodumper
```

### Option `MONGO_DB_NAMES`

For dump selective databases specify they names through space. This will create archives with names like `20170218_025718-db1` and `20170218_025718-db2` for each database from option.

Unfortunately now mongodump not providing opportunity to backups multiple databases at one time ([TOOLS-22](https://jira.mongodb.org/browse/TOOLS-22), [TOOLS-31](https://jira.mongodb.org/browse/TOOLS-31)).

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'MONGO_DB_NAMES=db1 db2' \       # names (through space) of databases for dumping
    tenorok/mongodumper
```

### Option `BACKUP_FILE_NAME`

For save backup with custom name. This option is more relevant for manual backup, because with scheduled backups file with specified name will overwritten each time.

```bash
docker run -d \
    -v /path/to/my-folder:/backup \
    --network=my-network \
    -e 'BACKUP_FILE_NAME=express' \     # custom name for backup archive
    tenorok/mongodumper
```
