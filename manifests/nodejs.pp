class cloud9::nodejs {

  class { 'apt': }

  package { 'python-software-properties':
    ensure => "installed",
  }

  package { 'g++':
    ensure => "installed",
  }

  package { 'make':
    ensure => "installed",
  }

  apt::ppa { 'ppa:chris-lea/node.js':
    require => [ Package['python-software-properties'], Package['g++'], Package['make']]
  }

  package { 'nodejs':
    ensure => "installed",
    require => [ Apt::Ppa['ppa:chris-lea/node.js'], ],
  }
}