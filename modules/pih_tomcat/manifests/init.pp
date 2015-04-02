class pih_tomcat (
    $tomcat = hiera('tomcat'),
    $tomcat_port = hiera('tomcat_port'),
    $tomcat_ssl_port = hiera('tomcat_ssl_port'),
    $tomcat_shutdown_port = hiera('tomcat_shutdown_port'),
    $tomcat_ajp_port = hiera('tomcat_ajp_port'),    
    $services_enable = hiera('services_enable'),
    $java_memory_parameters = hiera('java_memory_parameters'),
    $java_profiler = hiera('java_profiler'),
    $java_debug_parameters = hiera('java_debug_parameters'),
  ){

  require pih_java

  $tomcat_user_home_dir="/home/${tomcat}"
  $java_home = $pih_java::java_home
  $version = '6.0.36'
  $tomcat_zip = "apache-tomcat-${version}.tar.gz"
  
  $tomcat_parent = "/usr/share"
  $dest_tomcat_zip = "/tmp/${tomcat_zip}"
  
  $tomcat_home = "${tomcat_parent}/apache-${tomcat}-${version}"
  $cleanup_script = "${tomcat_home}/bin/cleanup.sh"

  $tomcat_base = "/var/lib/${tomcat}"
  $conf_server_xml = "${tomcat_base}/conf/server.xml"
  $policy_d_zip = 'policy.d.tar.gz'
  $dest_policy_d_zip = "${tomcat_base}/conf/${policy_d_zip}"
  
  notify{"tomcat_home= ${tomcat_home}": }

  user { $tomcat:
    ensure => 'present',
    home   => "${tomcat_user_home_dir}",
    shell  => '/bin/sh',
  } ->

  file { "${tomcat_user_home_dir}":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
  } ->

  file { $dest_tomcat_zip:
    ensure  => file,
    source  => "puppet:///modules/pih_tomcat/${tomcat_zip}",    
    mode    => '0755',
  } -> 

  exec { 'tomcat-unzip':
    cwd     => "/tmp/",
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_tomcat_zip}",
    unless  => "test -d ${tomcat_home}",   
  } ->

  exec { 'move-to-tomcat-home':
    cwd     => "/tmp/",
    command => "mv apache-tomcat-${version} ${tomcat_home}",
    unless  => "test -d ${tomcat_home}",   
  } ->

  file { "${tomcat_home}":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    recurse => true,    
  } ->

  file { "${tomcat_base}":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
  } ->

  file { "${tomcat_base}/common":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => true,   
  } ->

  file { "${tomcat_base}/server":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => true,   
  } ->

  file { "${tomcat_base}/shared":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => true,   
  } ->  

  file { "${tomcat_base}/conf":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    source  => "${tomcat_home}/conf/",
    recurse => true,   
  } ->    

  file { $dest_policy_d_zip:
    ensure  => file,
    source  => "puppet:///modules/pih_tomcat/${policy_d_zip}",    
    mode    => '0755',
  } -> 

  exec { 'policy-d-unzip':
    cwd     => "${tomcat_base}/conf",
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_policy_d_zip}",
    unless  => "test -d ${tomcat_base}/conf/policy.d",   
  } ->

  file { "${tomcat_base}/conf/policy.d":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',        
    recurse => true,   
  } ->  

  file { "${tomcat_base}/logs":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    source  => "${tomcat_home}/logs/",
    recurse => true,   
  } ->   

  file { "${tomcat_base}/webapps":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    source  => "${tomcat_home}/webapps/",
    recurse => true,   
  } ->

  file { "${tomcat_base}/work":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    source  => "${tomcat_home}/work/",
    recurse => true,   
  } ->        

  file { "${tomcat_parent}/${tomcat}":
    ensure  => 'link',
    target  => "${tomcat_home}",
    owner   => $tomcat,
    group   => $tomcat,    
  } ->
  
  file { $cleanup_script:
    ensure  => file,
    content => template("pih_tomcat/cleanup.sh.erb"),
    mode    => '0755',
  } -> 

  file { $conf_server_xml:
    ensure  => file,
    content => template("pih_tomcat/server.xml.erb"),
    owner   => $tomcat,
    group   => $tomcat,   
    mode    => '0600',
  } -> 

  file { "/etc/init.d/${tomcat}":
    ensure  => file,
    mode    => '0755',
    content => template("pih_tomcat/init.erb")
  } ->

  file { "/etc/default/${tomcat}":
    ensure  => file,
    content => template("pih_tomcat/default.erb")
  } ->

  file { "/etc/logrotate.d/${tomcat}":
    ensure  => file,    
    content => template("pih_tomcat/logrotate.erb"),
  } ->
  
  service { $tomcat:
    enable  => $services_enable,
    ensure  => "stopped",
  } ->

  package { 'sysv-rc-conf' :
    ensure => 'installed'
  } -> 

  exec { 'cleanup_tomcat':    
    cwd     => "${tomcat_home}/bin",    
    command => "${cleanup_script}",       
    logoutput => true,    
    returns   => [0, 1, 2],   
    timeout => 0,     
  } 

}
