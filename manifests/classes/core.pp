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

	if $::operatingsystem == 'Debian' {
		realize(File['/etc/apache2/sites-available/redmine', '/etc/apache2/sites-enabled/redmine'])
	}

	@file {
		'/etc/apache2/sites-available/redmine':
			owner => root,
			group => root,
			mode => 0644,
			content => 'RailsBaseURI /redmine',
			require => Package['redmine'];
		'/etc/apache2/sites-available/redmine':
			ensure => symlink,
			owner => root,
			group => root,
			mode => 0644,
			content => 'RailsBaseURI /redmine',
			require => File['/etc/apache2/sites-available/redmine'];
	}

	exec {
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
	}
}
