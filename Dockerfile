FROM mongo
MAINTAINER Ilya Stepanov <dev@ilyastepanov.com>

RUN apt-get update && \
    apt-get install -y cron && \
    rm -rf /var/lib/apt/lists/*

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

ADD start.sh /start.sh
RUN chmod +x /start.sh

RUN touch /var/log/cron.log

ADD crontab /crontab

VOLUME /backup

ENTRYPOINT ["/start.sh"]
CMD [""]
