#! /bin/bash
service tomcat6 stop
rm -rf ../conf/Catalina/localhost/openmrs.xml
rm -rf ../logs/*.*
rm -rf ../temp/*
rm -rf ../webapps/openmrs
rm -rf ../work/Catalina
