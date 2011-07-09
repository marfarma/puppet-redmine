class redmine::config {

	$production_db="redmine_production"
	$development_db="redmine_development"
	$redmine_db_user="redmine"
	$redmine_db_pass="redmine"

	file { 'database.yml':
		ensure => present,
		owner => $redmine_id,
		group => $redmine_id,
		path => $operatingsystem ? {
			Debian => '/etc/redmine/default/database.yml',
			Centos => '/usr/share/redmine/config/database.yml',
		},
		require => $operatingsystem ? {
			Debian => Package['redmine'],
			Centos => Exec['redmine_centos'],
		},
		content => template("redmine/database.yml.erb"),
	}

	file { '/var/www/redmine':
		ensure => link,
		target => '/usr/share/redmine/public',
		owner => $redmine_id,
		group => $redmine_id,
		require => Package['redmine'],
	}

	exec { 'config_redmine_production_db':
		command =>  '/usr/bin/mysqladmin -uroot create redmine_production',
		unless => '/bin/echo "show databases"|mysql -uroot|grep "redmine_production"',
		require => Class['mysql::packages'],
	}

	exec { 'config_redmine_development_db':
		command =>  '/usr/bin/mysqladmin -uroot create redmine_development',
		unless => '/bin/echo "show databases"|mysql -uroot|grep "redmine_development"',
#		require => Exec['config_redmine_production_db'],
	}

	exec { 'config_redmine_mysql_user':
		command =>  '/bin/echo "create user \'redmine\'@\'localhost\' identified by \'redmine\'"|mysql -uroot',
		unless => '/bin/echo "select user from mysql.user where user=\'redmine\'"|mysql -uroot|grep redmine',
		require => Exec['config_redmine_development_db'],
	}

	exec { 'config_redmine_production_perms':
		command => '/bin/echo "grant all on redmine_production.* to \'redmine\'@\'localhost\'"|mysql -uroot',
		require =>  Exec["config_redmine_mysql_user"],
	}

	exec { 'config_redmine_devel_perms':
		command => '/bin/echo "grant all on redmine_development.* to \'redmine\'@\'localhost\'"|mysql -uroot',
		require => Exec['config_redmine_production_perms'],
	}

	exec { 'config_redmine_mysql_bootstrap':
		environment => 'RAILS_ENV=production',
		path => '/usr:/usr/bin',
		cwd => '/usr/share/redmine',
#		provider => shell,
		command => 'sudo rake db:migrate',
		require => Exec['config_redmine_devel_perms'],
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
