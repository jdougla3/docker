#! /bin/bash

#set -x

cd /tmp
gunzip nibrs_analytics.sql.gz

/usr/bin/mysqld_safe --user=root &
until /usr/bin/mysqladmin -u root status > /dev/null 2>&1; do sleep 1; done

echo "create database nibrs_analytics" | mysql -u root
mysql -u root nibrs_analytics < /tmp/nibrs_analytics.sql
rm -f /tmp/nibrs_analytics.sql

#this assumes that the docker network is in the 172.18.0.0 subnet.
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.18.0.%' WITH GRANT OPTION" | mysql -u root