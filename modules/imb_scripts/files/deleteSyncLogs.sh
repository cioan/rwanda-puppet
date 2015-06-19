#!/bin/bash

# stop tomcat
service tomcat6 stop
mv /usr/share/tomcat6/.OpenMRS/sync/recrd /usr/share/tomcat6/.OpenMRS/sync/old_recrd
rm -rf /usr/share/tomcat6/.OpenMRS/sync/old_recrd
# start tomcat
service tomcat6 start