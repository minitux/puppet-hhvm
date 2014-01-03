class hhvm() { 

  file { '/etc/yum.repos.d/hop5.repo':
        mode    => 644,
        owner   => root,
        source  => 'puppet:///modules/hhvm/hop5.repo',
        require => Class['yum']
  }

  package { 'hhvm':
         ensure  => '2.3.2-1.el6',
         require => File['/etc/yum.repos.d/hop5.repo'],
  }

  file { '/etc/hhvm/': 
         ensure => directory,
         recurse => false,
         owner   => 'root',
         group   => 'root',
         mode    => '0755',
  }

  file { '/etc/hhvm/hhvm.hdf':
         ensure  => present,
         content => template ('hhvm/hhvm.hdf.erb'),
         mode    => '0644',
         owner   => 'root',
         group   => 'root',
         notify  => Service['hhvm'],
         require => [Package['hhvm'],File['/etc/hhvm/']],
  }

  file { '/etc/init.d/hhvm':
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/hhvm/init_script',
        require => File['/etc/hhvm/hhvm.hdf'],
  }


  service { 'hhvm':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/init.d/hhvm'], 
  }



}
