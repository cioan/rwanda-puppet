#! /bin/bash

service tomcat6 stop
service mysql.server stop
rm -rf /etc/default/tomcat6
rm -rf /etc/init.d/tomcat6
rm -rf /etc/mysql
rm -rf /etc/init.d/mysql.server
rm -rf /var/lib/tomcat6
rm -rf /usr/share/tomcat6
rm -rf /usr/local/mysql
rm -rf /usr/local/mysql-5.6.20.tar.gz
rm -rf /usr/share/apache-tomcat-6.0.36
rm -rf /usr/share/apache-tomcat-6.0.36.tar.gz
userdel tomcat6
rm -rf /home/tomcat6
