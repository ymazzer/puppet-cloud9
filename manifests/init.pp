class cloud9 (
  $dir = '/opt/cloud9',
  $user = 'cloud9',
  $group = 'cloud9',
  $source = 'https://github.com/ajaxorg/cloud9.git') {

  class { 'stdlib': }
  class { 'wget': }

  class { 'nodejs':
    version => 'v0.8.9',
    require => [ Package['wget'] ]
  }

  package { 'git':
    ensure => "installed",
  }

  exec { 'apt-update':
    command => "/usr/bin/apt-get update"
  }

  package { 'libxml2-dev':
    ensure => installed,
    require  => Exec['apt-update'],
  }

  vcsrepo { 'cloud9':
    ensure => latest,
    path => $dir,
    source => $source,
    provider => git,
    require => Package["git"],
    revision => 'master',
    owner => $user,
    group => $group,
  }

  exec { 'install-cloud9':
    command => "/usr/local/bin/npm install",
    cwd => $dir,
    require => [ Package["libxml2-dev"], Vcsrepo["cloud9"] ],
  }
}