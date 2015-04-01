Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }

notify{"hostname= ${hostname}": }


node default {
    
  include pih_java
  include pih_mysql
  include pih_tomcat

}
