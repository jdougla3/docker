#
# Copyright 2012-2016 SEARCH, The National Consortium for Justice Information Sharing and Statistics
# 


# Dockerfile that extends base saiku to add demo  nibrs data

FROM ojbc/saiku

MAINTAINER SEARCH "http://www.search.org"

WORKDIR /tmp

COPY files/server-config.sh /tmp/
COPY files/nibrs-analytics.connection.json /tmp/

RUN chmod a+x /tmp/server-config.sh
RUN /tmp/server-config.sh

RUN cd /opt/saiku-server/tomcat

CMD ["/opt/saiku-server/start-saiku.sh"]