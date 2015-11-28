# puppetlabs-java
# NOTE: Nexus requires

package { 'rubygems':
    ensure => present,
}

class { 'puppetdb':
}


