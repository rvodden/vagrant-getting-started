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

$pam_ldap_conf = @("PMLDP"/L)
uri ldap://ldap.c.audry-666.internal/
base dc=ilab,dc=paconsulting,dc=com
binddn cn=admin,dc=paconsulting,dc=com
bindpw secret
ssl no
tls_checkpeer no
pam_filter objectclass=posixAccount
pam_login_attribute uid
pam_groupdn cn=Allow Login,ou=Groups,dc=ilab,dc=myorganization,dc=com
pam_member_attribute member
pam_password md5
| PMLDP

$nslcd_conf = @("NSLCD"/L)
# /etc/openldap/ldap.conf

uid nslcd
gid ldap

uri ldap://ldap.c.audry-666.internal/
base dc=ilab,dc=paconsulting,dc=com
binddn cn=admin,dc=paconsulting,dc=com
bindpw secret
| NSLCD

node 'gitlab.c.audry-666.internal' {
  # puppetlabs-java

  package{ 'nss-pam-ldapd':
    ensure => 'installed',
  }

  file { '/etc/nslcd.conf':
  ensure  => 'present',
  content => $nslcd_conf,
  }

  file { '/etc/pam_ldap.conf':
  ensure  => 'present',
  content => $pam_ldap_conf,
  mode    => '0700',
  }

  file { "/etc/pam_debug":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
 }

  file { "/etc/rsyslog.d/debug.conf":
    content => "*.debug /var/log/debug.log\n",
    owner   => root,
    group   => root,
    mode    => '0644',
 }

  class { 'nsswitch':
  passwd => ['files', 'ldap'],
  shadow => ['files', 'ldap'],
  group  => ['files', 'ldap'],
  }

  class { 'gitlab':
        external_url => 'http://gitlab.vodden.com',
  }

  class { 'openldap::client':
      base => 'dc=ilab,dc=paconsulting,dc=com',
      uri  => ['ldap://ldap.c.audry-666.internal' ],
  }

  file { '/etc/systemd/system/default.target.wants/gitlab-runsvdir.service':
      ensure => 'link',
      target => '/opt/gitlab/embedded/cookbooks/runit/files/default/gitlab-runsvdir.service'
  }

  exec { 'enable_ldap':
  command => '/sbin/authconfig --enableldap --enableldapauth --ldapserver=ldap.c.audry-666.internal --ldapbasedn="dc=ilab,dc=paconsulting,dc=com" --enablemkhomedir --update',
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
    ensure    => present,
    rootdn    => 'cn=admin,dc=paconsulting,dc=com',
    rootpw    => '{SSHA}fFCuroBNNd4ZssINg1ySDcki9/BL1AAg'
  }

  openldap::server::schema { 'core':
    ensure  => present,
    path    => '/etc/openldap/schema/core.schema',
  }

  openldap::server::schema { 'cosine':
    ensure  => present,
    path    => '/etc/openldap/schema/cosine.schema',
    require => Openldap::Server::Schema["core"],
  }

  openldap::server::schema { 'inetorgperson':
    ensure  => present,
    path    => '/etc/openldap/schema/inetorgperson.schema',
    require => Openldap::Server::Schema["core"],
  }

  openldap::server::schema { 'nis':
    ensure  => present,
    path    => '/etc/openldap/schema/nis.schema',
    require => Openldap::Server::Schema["core"],
  }

  file { '/etc/rsyslog.d/slapd.conf':
    ensure  => file,
    content => "local4.debug            /var/log/slapd.log\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
