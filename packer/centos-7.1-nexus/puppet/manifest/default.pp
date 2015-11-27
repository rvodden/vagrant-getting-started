# puppetlabs-java
# NOTE: Nexus requires
class{ '::java':
  distribution => 'jdk'
}

file { '/opt/nexus':
      ensure => 'directory',
}

class{ '::nexus':
  version        => '2.11.4',
  revision       => '01',
  nexus_user     => 'nexus',
  nexus_group    => 'nexus',
  nexus_root     => '/opt/nexus' # All directories and files will be relative to this
}

package { 'createrepo':
      ensure => 'installed',
}

  Class['::java'] ->
  Class['::nexus']

