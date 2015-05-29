class imb_scripts(
	$tomcat = hiera('tomcat'),
 ){

	require pih_tomcat

	$tomcat_home = $pih_tomcat::tomcat_home
	$uninstall_script = "/etc/puppet/uninstall-${tomcat}.sh"

	file { $uninstall_script:
		ensure  => file,
		content => template("imb_scripts/uninstall.sh.erb"),
		mode    => '0755',
	}
	
}