class redmine::pre {
	case $operatingsystem {
		Centos: { include redmine::pre::centos }
		Debian: { include redmine::pre::debian }
	}

	class centos {
		exec {
			'yum update':
				command => 'yum update',
				path => '/usr/bin',
		}
	}

	class debian {
		exec {
			'apt update':
				command => 'apt-get update',
				path => '/usr/bin';
		}
	}
}
