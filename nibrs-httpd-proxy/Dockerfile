#
# Copyright 2012-2016 SEARCH, The National Consortium for Justice Information Sharing and Statistics
# 

# Dockerfile for Apache HTTPD 2.4 that runs mod_proxy

FROM httpd:2.4-alpine

MAINTAINER SEARCH "http://www.search.org"

RUN printf "\nInclude /usr/local/apache2/conf/proxy.conf\n" >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80

COPY files/proxy.conf /usr/local/apache2/conf



	