class pih_java {
    
    $jdk_6u45 = "jdk-6u45-linux-x64.bin"
    $jdk_version = "jdk1.6.0_45"    	
	$opt_java = "/opt/java/64"
	$opt_java_dir = [ "/opt/java/", "/opt/java/64", ]	
	$jdk_install = "${opt_java}/${jdk_6u45}"

	$java_home = "${opt_java}/${jdk_version}"

	file { $opt_java_dir:
		ensure  => directory,
	} -> 
	
	file { $jdk_install:
		ensure  => file,
		source	=> "puppet:///modules/pih_java/${jdk_6u45}",		
		mode    => '0755',
	} -> 

	exec {'install_java':
		cwd			=> $opt_java,
		command     => "bash -c ${jdk_install}",
		user        => 'root',
	} ->

	exec {'update_java_alternative':
		cwd			=> $opt_java,
		command     => "update-alternatives --install \"/usr/bin/java\" \"java\" \"${java_home}/bin/java\" 1",
		user        => 'root',
	} -> 

	exec {'set_java_default':
		cwd			=> $opt_java,
		command     => "update-alternatives --set java ${java_home}/bin/java",
		user        => 'root',
	} 
}