node 'nexus.c.audry-666.internal' {
  class { 'java':
    distribution => 'jdk'
  }

  file { '/opt/nexus':
    ensure => 'directory',
  }

  class{ '::nexus':
    version     => '2.11.4',
    revision    => '01',
    nexus_user  => 'nexus',
    nexus_group => 'nexus',
    nexus_root  => '/opt/nexus'
  }

  package { 'createrepo':
    ensure => 'installed',
  }

Class['::java'] -> Class['::nexus']
}

node 'gitlab.c.audry-666.internal' {
  # puppetlabs-java

  class { 'gitlab':
        external_url => 'http://gitlab.vodden.com',
  }

  file { '/etc/systemd/system/default.target.wants/gitlab-runsvdir.service':
      ensure => 'link',
      target => '/opt/gitlab/embedded/cookbooks/runit/files/default/gitlab-runsvdir.service'
  }
}

node 'ldap.c.audry-666.internal' {
  class { 'firewall': }

  class { 'openldap::server': }

  firewall { '000 accept all ldap requests':
    dport  => 389,
    proto  => tcp,
    action => accept,
  }

  openldap::server::database { 'dc=paconsulting,dc=com':
    ensure => present,
    rootdn => 'cn=admin,dc=paconsulting,dc=com',
    rootpw => '{SSHA}fFCuroBNNd4ZssINg1ySDcki9/BL1AAg'
  }

  openldap::server::schema { 'core':
    ensure => present,
    path   => '/etc/openldap/schema/core.schema',
  }

  openldap::server::schema { 'cosine':
    ensure  => present,
    path    => '/etc/openldap/schema/cosine.schema',
    require => Openldap::Server::Schema['core'],
  }

  openldap::server::schema { 'inetorgperson':
    ensure  => present,
    path    => '/etc/openldap/schema/inetorgperson.schema',
    require => Openldap::Server::Schema['core'],
  }

  openldap::server::schema { 'nis':
    ensure  => present,
    path    => '/etc/openldap/schema/nis.schema',
    require => Openldap::Server::Schema['core'],
  }

}
