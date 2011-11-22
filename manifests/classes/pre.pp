class redmine::pre {
	user { 'puppet':
		ensure => present,
		gid => 'puppet',
	}

	group { 'puppet':
		ensure => present,
	}

	@exec {
		'apt update':
			command => 'apt-get update',
			path => '/usr/bin';

		'yum update':
			command => 'yum update -y',
			path => '/usr/bin';
	}

	case $::operatingsystem {
		Centos: {realize(Exec['yum update'])}
		Debian: {realize(Exec['apt update'])}
	}
}
