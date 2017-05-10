#
# Copyright 2012-2016 SEARCH, The National Consortium for Justice Information Sharing and Statistics
# 

# Dockerfile with database layer to support NIBRS demos

FROM ojbc/mysql

MAINTAINER SEARCH "http://www.search.org"

WORKDIR /tmp

COPY files/server-config.sh /tmp/
COPY files/nibrs_analytics.sql.gz /tmp/


RUN chmod a+x /tmp/server-config.sh
RUN /tmp/server-config.sh

WORKDIR /usr

CMD ["bin/mysqld_safe", "--user=root"]