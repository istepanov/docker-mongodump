docker-mongodump
================

Docker image with mongodump running as a cron task

### How To Use
First you have to build docker image from the repository:
```docker build -t istepanov/mongodump .```
After that you can install backup job for your mongodb docker container as follows (basically provide container name as an argument to install-backup.sh script):
```
$ docker ps
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS              PORTS                    NAMES
ea3a814c3720        campus2020portal_web:latest   "node app.js"          6 days ago          Up 5 days           0.0.0.0:8080->8080/tcp   campus2020portal_web_1     
39cae58c3dc8        mongo:latest                  "/entrypoint.sh mong   4 weeks ago         Up 5 days           27017/tcp                campus2020portal_mongo_1
$ ./install-backup.sh campus2020portal_mongo_1
```
This will run a docker container with cron job installed inside, which will backup mongodb once a day at 1.00 A.M. and save the output to /var/backups/mongodb as a .tar.gz archive. When you run docker via remote access (i.e. access remote docker host), the data will be saved on remote machine!
For configuration options, please, take a look inside the scripts. Crontab schedule is available in crontab file and `0 1 * * *` by default.

To run backup once you can use the following script:
```
$ ./run-backup.sh campus2020portal_mongo_1
```
