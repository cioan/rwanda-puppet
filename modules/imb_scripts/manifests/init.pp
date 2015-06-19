class imb_scripts(
	$backups_user_password = hiera('backups_user_password'),
	$tomcat = hiera('tomcat'),
	){
	
	require imb_users
	require pih_tomcat

	$backups_user = "backups"
	$add_user_sh = $imb_users::add_user_sh
    $tomcat_home = $pih_tomcat::tomcat_home
	$openmrs_folder = "${tomcat_home}/.OpenMRS"
	$backups_scripts_folder = "/home/${backups_user}/scripts"

	$deleteSyncLogs_sh = "${backups_scripts_folder}/deleteSyncLogs.sh"

#   Add backups user
#   -----------------
	exec { 'add_backups':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} backups $backups_user_password sudo",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} ->


#   Create backups/scripts directory
#   --------------------------------
	file { $backups_scripts_folder:
		ensure  => directory,
		owner   => $backups_user,
		group   => $backups_user,
		mode    => '0755',
	} ->

#   Install deleteSyncLogs.sh script
#   --------------------------------
	file { $deleteSyncLogs_sh: 
		ensure  => present,  
		content => template('imb_scripts/deleteSyncLogs.sh.erb'), 
		mode    => '0755',
	} ->

#   Add deleteSyncLogs.sh script to the root's crontab
#   --------------------------------
	cron { 'delete-openmrs-sync-logs':
		ensure  => present,
		command => "${deleteSyncLogs_sh} > /dev/null",
		user    => 'root',
		hour    => 0,
		minute  => 3
	}	
}