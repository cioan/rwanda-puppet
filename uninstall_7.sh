#! /bin/bash

service tomcat7 stop
service mysql.server stop
rm -rf /etc/default/tomcat7
rm -rf /etc/init.d/tomcat7
rm -rf /etc/mysql
rm -rf /etc/init.d/mysql.server
rm -rf /var/lib/tomcat7
rm -rf /usr/share/tomcat7
rm -rf /usr/local/mysql
rm -rf /usr/local/mysql-5.6.15.tar.gz
rm -rf /usr/share/apache-tomcat-7.0.62
rm -rf /usr/share/apache-tomcat-7.0.62.tar.gz
userdel tomcat7
rm -rf /home/tomcat7
