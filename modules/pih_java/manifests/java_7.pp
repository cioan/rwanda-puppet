class pih_java::java_7 {
    
    $jdk1_7_0_80 = "jdk-7u80-linux-x64.tar"
    $jdk_version = "jdk1.7.0_80"    	
	$opt_java = "/opt/java/64"
	$opt_java_dir = [ "/opt/java/", "/opt/java/64", ]	
	$jdk_install = "${opt_java}/${jdk1_7_0_80}"

	$java_home = "${opt_java}/${jdk_version}"

	notify{"java_home= ${java_home}": }

	file { $opt_java_dir:
		ensure  => directory,
	} -> 
	
	file { $jdk_install:
		ensure  => file,
		source	=> "puppet:///modules/pih_java/${jdk1_7_0_80}",		
		mode    => '0755',
	} -> 

	exec { 'java-unzip':
		cwd     => $opt_java,
		command => "tar -xf ${jdk_install}",
		unless  => "test -d ${java_home}",   
		user        => 'root',
	} ->

	exec {'update_java_alternative':
		cwd			=> $opt_java,
		command     => "update-alternatives --install \"/usr/bin/java\" \"java\" \"${java_home}/bin/java\" 1",
		user        => 'root',
	} -> 

	exec {'set_java_default':
		cwd	    => $opt_java,
		command     => "update-alternatives --set java ${java_home}/bin/java",
		user        => 'root',
	} 
}
