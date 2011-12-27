class redmine::pre {
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

	exec {
		'selinux_permissive':
			path => '/bin:/usr/bin:/usr/sbin',
			command => 'setenforce permissive',
			unless => 'cat /etc/selinux/config|grep "SELINUX=disabled"',
			onlyif => 'which setenforce';
	}
}
