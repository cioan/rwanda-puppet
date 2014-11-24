Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin/' ] }

notify{"hostname= ${hostname}": }

$tomcat_home = hiera('tomcat_home')

node default {
    
  include newrelic
  include mailx
  include logging
}
