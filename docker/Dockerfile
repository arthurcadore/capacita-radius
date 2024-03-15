FROM freeradius/freeradius-server:3.2.3-alpine

RUN apk add --no-cache net-tools

COPY docker/startup.sh /startup.sh

RUN chmod +x /startup.sh

CMD ["/startup.sh"]

