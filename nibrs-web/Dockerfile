# Dockerfile for a Tomcat container that runs the nibrs validation app
# Note that you need to build the nibrs-web war file first, and copy into the bin directory before building or pushing to dockerhub

FROM ojbc/java8-tomcat8

MAINTAINER Open Justice Broker Consortium "http://www.ojbc.org"

COPY bin/nibrs_web.war /opt/tomcat/webapps/nibrs_web.war

CMD ["catalina.sh", "run"]
