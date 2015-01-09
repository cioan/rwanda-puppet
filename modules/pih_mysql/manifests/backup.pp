class pih_mysql::backup (
    $backup_user = hiera('backup_db_user'),
    $backup_password = hiera('backup_db_password'),
    $remote_db_user = hiera('remote_db_user'),
    $remote_db_server = hiera('remote_db_server'),
    $remote_backup_dir = hiera('remote_backup_dir'),
    $openmrs_db = hiera('openmrs_db'),
    $tomcat = hiera('tomcat')
  ){

  require openmrs

  mysql_user { "${backup_user}@localhost":
    ensure        => present,
    password_hash => mysql_password($backup_password),
    provider      => 'mysql',
    require       => Service['mysqld'],
  } ->

  mysql_grant { "${backup_user}@localhost/*.*":
    ensure  => 'present',
    options => ['GRANT'],
    table   => '*.*',
    user    => "${backup_user}@localhost",
    privileges => [ 'SELECT', 'RELOAD', 'LOCK TABLES', 'REPLICATION CLIENT', 'REPLICATION SLAVE', 'SHOW VIEW' ],
    
  } -> 

  package { 'p7zip-full' :
  	  ensure => 'installed'
  } ->

  file { 'mysqlbackup.sh':
    ensure  => present,
    path    => '/usr/local/sbin/mysqlbackup.sh',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    content => template('pih_mysql/mysqlbackup.sh.erb'),
  } ->

  cron { 'mysql-backup':
    ensure  => present,
    command => '/usr/local/sbin/mysqlbackup.sh',
    user    => 'root',
    hour    => 1,
    minute  => 30,    
  }
  
}
