class redmine::pre {
	@exec {
		'gem update':
			command => 'gem update --system',
			path => '/usr/bin:/opt/ruby/bin';

		'apt update':
			command => 'apt-get update',
			path => '/usr/bin';

		'yum update':
			command => 'yum update -y',
			path => '/usr/bin';
	}

#	realize(Exec['gem update'])

	case $operatingsystem {
		Centos: {realize(Exec['yum update'])}
		Debian: {realize(Exec['apt update'])}
	}
}
