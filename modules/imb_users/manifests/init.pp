class imb_users(
	$default_new_user_password = hiera('default_new_user_password'),

	){
	
	$add_user_sh = "/etc/puppet/addUser.sh"

	file { $add_user_sh: 
		ensure  => present,  
		source  => "puppet:///modules/imb_users/addUser.sh",
		mode    => '0700',
	} ->
	
	exec { 'add_rubailly':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} rubailly $default_new_user_password",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} ->

	exec { 'add_gneza':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} gneza $default_new_user_password",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} ->

	exec { 'add_jberchmas':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} jberchmas $default_new_user_password",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} ->

	exec { 'add_innocentk':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} innocentk $default_new_user_password",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} ->

	exec { 'add_ekagabo':    
		cwd     => "/etc/puppet",    
		command => "${add_user_sh} ekagabo $default_new_user_password",       
		logoutput => true,    
		returns   => [0, 1, 2],   
		timeout => 0,     
	} 
}