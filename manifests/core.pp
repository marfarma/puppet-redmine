class redmine::core {
	$redmine_id = $operatingsystem ? {
		/Debian|Ubuntu/ => 'www-data',
		Centos => 'apache',
	}

	group { 'redmine':
		ensure => present,
		name => "$redmine_id",
	}	

	user { 'redmine':
		ensure => present,
		name => "$redmine_id",
		gid => "$redmine_id",
		require => Group["$redmine_id"],
	}

	@file { '/etc/apache2/sites-available/redmine':
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		content => 'RailsBaseURI /redmine',
		require => Package['redmine'],
	}

	@exec { 'config_redmine_link_apache':
		command => '/usr/sbin/a2ensite redmine',
		require => File['/etc/apache2/sites-available/redmine'],
		unless => '/usr/bin/test -f /etc/apache2/sites-enabled/redmine',
	}

	case $operatingsystem {
		'Centos': {realize(Exec['build_passenger_modules', 'selinux_disable', 'session_store', 'apache_modules'], File['redmine.conf'])}
		'Debian': {realize(File['redmine_apache.conf'], Exec['redmine_site_enable'])}
	}

	@file {
		'redmine.conf':
			name => '/etc/httpd/conf.d/redmine.conf',
			ensure => present,
			content => template('redmine/templates/apache_redmine.conf'),
			notify => Service['apache'];
	}

	@exec {
		'build_passenger_modules':
			path => '/bin:/usr/bin:/opt/ruby/bin',
			command => 'passenger-install-apache2-module -a',
#			require => Package['passenger'],
			unless => 'test -f /opt/ruby/lib/ruby/gems/1.8/gems/passenger-3.0.7/ext/apache2/mod_passenger.so';

		'selinux_disable':
			path => '/bin:/usr/bin',
			command => 'system-config-securitylevel-tui -q --selinux="disabled"',
			unless => 'cat /etc/selinux/config|grep "SELINUX=disabled"',
			before => Service['apache'],
			notify => Service['apache'];

		'session_store':
			path => '/bin:/usr/bin:/opt/ruby/bin',
			command => '/bin/sh -c "cd /usr/share/redmine/public && rake generate_session_store"',
			require => Package['gem_rails'];

		'apache_modules':
			path => '/bin:/usr/bin',
			command => 'echo -e "LoadModule passenger_module /opt/ruby/lib/ruby/gems/1.8/gems/passenger-3.0.7/ext/apache2/mod_passenger.so\nPassengerRoot /opt/ruby/lib/ruby/gems/1.8/gems/passenger-3.0.7\nPassengerRuby /opt/ruby/bin/ruby" >> /etc/httpd/conf/httpd.conf',
			unless => 'cat /etc/httpd/conf/httpd.conf|grep "LoadModule passenger_module"',
#			require => [ Class['apache::mod::passenger'], Package['rubygems'] ],
			notify => Service['apache'];
	}
}
