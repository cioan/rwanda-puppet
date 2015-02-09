class openmrs (
    $mysql_root_password = hiera('mysql_root_password'),
    $openmrs_db = hiera('openmrs_db'),
    $openmrs_db_user = hiera('openmrs_db_user'),
    $openmrs_db_password = hiera('openmrs_db_password'),
    $openmrs_auto_update_database = hiera('openmrs_auto_update_database'),    
    $tomcat = hiera('tomcat'),    
  ){

  require pih_java
  require pih_mysql
  require pih_tomcat

  $tomcat_home = $pih_tomcat::tomcat_home
  $tomcat_base = $pih_tomcat::tomcat_base
  $tomcat_user_home_dir = $pih_tomcat::tomcat_user_home_dir

  $openmrs_folder = "${tomcat_home}/.OpenMRS"
  $openmrs_db_folder = "${openmrs_folder}/db"
  $runtime_properties_file = "${openmrs_folder}/openmrs-runtime.properties"
  $openmrs_db_tar = "openmrs.tar.gz"
  $dest_openmrs_db = "${openmrs_db_folder}/openmrs.tar.gz"
  $openmrs_create_db_sql = "${openmrs_db_folder}/dropAndCreateDb.sql"
  $delete_sync_tables_sql = "${openmrs_db_folder}/deleteSyncTables.sql"
  $restore_openmrs_db_sh = "${openmrs_db_folder}/restoreOpenMRS-db.sh"
  $openmrs_dump_sql = "${openmrs_db_folder}/openmrs.sql"
  $modules_tar = "modules.tar.gz" 
  $dest_modules_tar = "${openmrs_folder}/${modules_tar}"
  $dest_openmrs_war = "${tomcat_base}/webapps/openmrs.war"

  notify{"tomcat_base= ${tomcat_base}": }
  notify{"tomcat= ${tomcat}": }

  file { $openmrs_folder:
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',
    require => User[$tomcat]
  } ->

  file { "${tomcat_user_home_dir}/.OpenMRS":
    ensure => link,
    target => "${openmrs_folder}",  
  } ->

  file { $openmrs_db_folder:
    ensure  => directory,    
  } ->

  file { $dest_modules_tar:
    ensure  => file,
    owner   => $tomcat,
    group   => $tomcat,
    source  => "puppet:///modules/openmrs/${modules_tar}",    
    mode    => '0755',
  } -> 

  exec { 'modules-unzip':
    cwd     => $openmrs_folder,
    command => "tar --group=${tomcat} --owner=${tomcat} -xzf ${dest_modules_tar}",    
  } ->

  file { "${openmrs_folder}/modules":
    ensure  => directory,
    owner   => $tomcat,
    group   => $tomcat,
    mode    => '0755',    
    recurse => inf,
  } ->

  file { $dest_openmrs_war:
    ensure  => file,
    source  => "puppet:///modules/openmrs/openmrs.war",    
    mode    => '0755',
    owner   => $tomcat,
    group   => $tomcat,
  } 

}
