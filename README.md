istepanov/mongodump
===================

Docker image with `mongodump`, `cron` and AWS CLI to upload backups to AWS S3.

### Environment variables

| Env var               | Description | Default                 |
|-----------------------|-------------|-------------------------|
| `MONGO_URI`             | Mongo URI.  | `mongodb://mongo:27017` |
| `CRON_SCHEDULE`         | Cron schedule. Leave empty to disable cron job. | `''` |
| `TARGET_FOLDER`         | Local folder (inside the container) to save backups. Mount volume to this folder. Set it to null (empty string) to disable local backups (this will make `TARGET_S3_FOLDER` a required parameter). | `'/backup'` |
| `TARGET_S3_FOLDER`      | Folder to upload backups. Leave it empty to disable upload to S3. | `''` |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID. Leave empty if you want to use AWS IAM Role instead. | `''` |
| `AWS_SECRET_ACCESS_KEY` | AWS Access Key ID. Leave empty if you want to use AWS IAM Role instead. | `''` |

### Examples

Run container with cron job (once a day at 1am), save backup to `/path/to/target/folder`, upload backups to AWS S3 folder:

    docker run -d \
      -v /path/to/target/folder:/backup \
      -e 'MONGO_URI=mongodb://mongo:27017' \
      -e 'CRON_SCHEDULE=0 1 * * *' \
      -e 'TARGET_S3_FOLDER=s3://my_bucket/backup/' \
      -e 'AWS_ACCESS_KEY_ID=my_aws_key' \
      -e 'AWS_SECRET_ACCESS_KEY=my_aws_secret' \
      istepanov/mongodump:4.2

Same, but runs once, no cron job:

    docker run -ti \
      -v /path/to/target/folder:/backup \
      -e 'MONGO_URI=mongodb://mongo:27017' \
      -e 'TARGET_S3_FOLDER=s3://my_bucket/backup/' \
      -e 'AWS_ACCESS_KEY_ID=my_aws_key' \
      -e 'AWS_SECRET_ACCESS_KEY=my_aws_secret' \
      istepanov/mongodump:4.2

Run container with cron job (once a day at 1am), upload backups to AWS S3 folder, do not create local backups:

    docker run -d \
      -e 'MONGO_URI=mongodb://mongo:27017' \
      -e 'CRON_SCHEDULE=0 1 * * *' \
      -e 'TARGET_FOLDER=' \
      -e 'TARGET_S3_FOLDER=s3://my_bucket/backup/' \
      -e 'AWS_ACCESS_KEY_ID=my_aws_key' \
      -e 'AWS_SECRET_ACCESS_KEY=my_aws_secret' \
      istepanov/mongodump:4.2

Docker Compose example - run container with cron job (once a day at 1am), save backup to `mongo-backup` volume:

    version: '3'

    services:
      mongo:
        image: "mongo:4.2"

      mongo-backup:
        image: "istepanov/mongodump:4.2"
        volumes:
          - mongo-backup:/backup
        environment:
          MONGO_URI: "mongodb://mongo:27017"
          CRON_SCHEDULE: "0 1 * * *"
        depends_on:
          - mongo

    volumes:
      mongo-backup:
