class logging (
  $email_alerts_to = hiera('email_alerts_to'),
  ){
    
  require mailx

  file { '/etc/logstash/conf.d/logstash.conf':
    ensure  => file,
    content => template('logging/logstash.conf.erb'),
    require => File['/etc/logstash/conf.d'],
    notify  => Service['logstash']
  }

  class { 'logstash':
    provider     => 'custom',
    jarfile      => 'puppet:///modules/logging/logstash-1.1.9-monolithic.jar',
    installpath  => '/usr/local/logstash',
    defaultsfile => 'puppet:///modules/logging/logstash_default'
  }
}
