FROM freeradius/freeradius-server:3.2.3-alpine

COPY docker/startup.sh /startup.sh

RUN chmod +x /startup.sh

CMD ["/startup.sh"]

