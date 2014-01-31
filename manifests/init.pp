class cloud9 (
  $dir = '/opt/cloud9',
  $user = 'cloud9',
  $group = 'cloud9',
  $source = 'https://github.com/ajaxorg/cloud9.git',
  $workspace = '~/',
  $listen = 'localhost',
  $version = 'master') {

  class { 'cloud9::nodejs': }

  package { 'git':
    ensure => "installed",
  }

  # Required by cloud9 when using node >= 0.10
  package { 'mercurial':
    ensure => installed
  }

  package { 'libxml2-dev':
    ensure => installed
  }

  vcsrepo { 'cloud9':
    ensure => latest,
    path => $dir,
    source => $source,
    provider => git,
    require => Package["git"],
    revision => $version,
    owner => $user,
    group => $group,
  }

  exec { 'install-cloud9':
    command => "npm install",
    cwd => $dir,
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ],
    require => [ Package["libxml2-dev"], Class['cloud9::nodejs'], Vcsrepo["cloud9"] ],
  }

  file { 'start-script':
      path => "${dir}/start-workspace.sh",
      ensure => 'file',
      content => "#!/bin/sh
      sh ${dir}/bin/cloud9.sh -l ${listen} -w ${workspace}",
      owner => $user,
      group => $group,
      mode => 755,
      require => [ Exec["install-cloud9"] ]
  }

}