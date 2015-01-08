class pih_tomcat (
    $tomcat = hiera('tomcat'),
    $services_enable = hiera('services_enable'),
    $java_memory_parameters = hiera('java_memory_parameters'),
    $java_profiler = hiera('java_profiler'),
    $java_debug_parameters = hiera('java_debug_parameters'),
  ){

  require pih_java

  $java_home = $pih_java::java_home
  $tomcat_zip = 'apache-tomcat-6.0.36.tar.gz'
  $tomcat_parent = "/usr/share"
  $dest_tomcat_zip = "${tomcat_parent}/${tomcat_zip}"
  $version = '6.0.36'
  $tomcat_home = "${tomcat_parent}/apache-tomcat-${version}"
  $tomcat_base = "/var/lib/${tomcat}"
  $cleanup_script = "${tomcat_home}/bin/cleanup.sh"


  notify{"tomcat_home= ${tomcat_home}": }

  user { $tomcat:
    ensure => 'present',
    home   => "/home/${tomcat}",
    shell  => '/bin/sh',
  } ->

  file { "/home/${tomcat}":
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
    cwd     => $tomcat_parent,
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_tomcat_zip}",
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
    source  => "${tomcat_home}/common/", 
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
    source  => "puppet:///modules/pih_tomcat/cleanup.sh",    
    mode    => '0755',
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

  exec { 'cleanup_tomcat':
    cwd     => "${tomcat_home}/bin",
    command => "${cleanup_script}",    
    logoutput => true, 
    returns   => [0, 1, 2],
    timeout => 0, 
  } ->

  service { $tomcat:
    enable  => $services_enable,
    ensure  => running,
  } ->
  
  package { 'sysv-rc-conf' :
    ensure => 'installed'
  } 
}
