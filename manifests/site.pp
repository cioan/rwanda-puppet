Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }

notify{"hostname= ${hostname}": }


node default {
    
  include pih_java::java_7
  include pih_tomcat
  include pih_mysql
  include openmrs
}
