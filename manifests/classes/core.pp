class redmine::core {
	$redmine_id = $::operatingsystem ? {
		archlinux => 'http',
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

	case $::operatingsystem {
		default: {realize(Exec['session_store'])}
		centos: {realize(Exec['selinux_permissive', 'session_store'])}
		debian: {realize(File['sites-available redmine'], Exec['redmine site enable'])}
	}

	@file {
		'sites-available redmine':
			path => '/etc/apache2/sites-available/redmine',
			ensure => present,
			owner => root,
			group => root,
			mode => 0644,
			content => 'RailsBaseURI /redmine',
			require => Package['redmine'];
	}

	@exec {
		'selinux_permissive':
			path => '/bin:/usr/bin:/usr/sbin',
			command => 'setenforce permissive',
			unless => 'cat /etc/selinux/config|grep "SELINUX=disabled"',
			onlyif => 'which setenforce';

		'session_store':
			path => '/bin:/usr/bin:/opt/ruby/bin',
			cwd => '/usr/share/redmine/public',
			provider => 'shell',
			command => 'rake generate_session_store',
			require => Package['gem_rails'];

		'redmine site enable':
			command => '/usr/sbin/a2ensite redmine',
			require => File['/etc/apache2/sites-available/redmine'],
			unless => '/usr/bin/test -f /etc/apache2/sites-enabled/redmine';
	}
}
