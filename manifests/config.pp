class redmine_config {
	file { '/var/www/redmine':
		ensure => link,
		target => '/usr/share/redmine/public',
		owner => $redmine_id,
		group => $redmine_id,
		require => Package['redmine'],
	}

	exec { 'config_redmine_mysql_db':
		command =>  '/usr/bin/mysqladmin -uroot create redmine',
		unless => '/bin/echo "show databases"|mysql -uroot|grep redmine',
		require => Class['mysql_packages'],
	}

	exec { 'config_redmine_mysql_user':
		command =>  '/bin/echo "create user \'redmine\'@\'localhost\' identified by \'redmine\'"|mysql -uroot',
		unless => '/bin/echo "select user from mysql.user where user=\'redmine\'"|mysql -uroot|grep redmine',
		require => Exec['config_redmine_mysql_db'],
	}

	exec { 'config_redmine_mysql_permissions':
		command => '/bin/echo "grant all on redmine.* to \'redmine\'@\'localhost\'"|mysql -uroot',
		require =>  Exec["config_redmine_mysql_user"],
	}

	exec { 'config_redmine_mysql_bootstrap':
		environment => 'RAILS_ENV=production',
		path => '/usr:/usr/bin:/opt/ruby/bin',
		command => '/bin/sh -c "cd /usr/share/redmine && sudo /opt/ruby/bin/rake db:migrate"',
		require => Exec['config_redmine_mysql_permissions'],
	}

	exec { 'config_redmine_reload':
		command => $operatingsystem ? {
			Debian => '/etc/init.d/apache2 reload',
			Centos => '/etc/init.d/httpd reload',
		},
		require => Exec['config_redmine_mysql_bootstrap'],
		notify => Service['apache'],
	}
}
