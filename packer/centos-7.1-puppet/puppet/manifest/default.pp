# puppetlabs-java
# NOTE: Nexus requires

package { 'rubygems':
    ensure => present,
}

class { 'puppetdb':
}

file { '/etc/puppetlabs/puppet/autosign.conf':
  ensure  => 'present',
  content => '*.audry-666.internal',
}

service { 'puppetserver':
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}
