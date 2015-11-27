# puppetlabs-java

class { 'gitlab':
    external_url => 'http://gitlab.vodden.com',
}

file { '/etc/systemd/system/default.target.wants/gitlab-runsvdir.service':
  ensure => 'link',
  target => '/etc/systemd/system/default.target.wants/gitlab-runsvdir.service'
}

service { 'gitlab-runsvdir':
  ensure => 'running'
}
