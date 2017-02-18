FROM mongo:3.4
MAINTAINER Artem Kurbatov <mail@tenorok.ru>

RUN apt-get update && \
    apt-get install -y cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

ADD start.sh /start.sh
RUN chmod +x /start.sh

VOLUME /backup

ENTRYPOINT ["/start.sh"]
