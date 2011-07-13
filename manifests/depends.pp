class redmine::depends {
	package {
		redmine:
			ensure => installed,
			name => $operatingsystem ? {
				Centos => 'redmine_client',
				Debian => 'redmine',
			},
			provider => $operatingsystem ? {
				Centos => "gem",
				Debian => "apt",
			},
			before => Exec["config_redmine_mysql_bootstrap"];
#			require => [ User['redmine'], Class['apache::packages', 'mysql::packages'] ],

		'gem_i18n':
			ensure => '0.4.2',
			name => 'i18n',
			provider => gem,
			before => Package['gem_rails'];

		'gem_mysqlplus':
			ensure => installed,
			name => 'mysqlplus',
			provider => gem,
			require => Package['gem_i18n'];

		'gem_rack':
			ensure => $operatingsystem ? {
				Centos => '1.1.1',
				Debian => '1.0.1',
			},
			name => 'rack',
			provider => gem,
			before => Package['gem_rails'];

		'gem_rake':
			ensure => '0.8.7',
			name => 'rake',
			provider => 'gem';
/*
		'gem_hoe':
			ensure => installed,
			name => 'hoe',
			provider => gem,
			before => Package['gem_rails'];
*/

		'gem_rails':
			ensure => $operatingsystem ? {
				Centos => '2.3.11',
				Debian => '2.3.5',
			},
			name => 'rails',
			provider => gem,
			before => Exec['config_redmine_mysql_bootstrap'];

		'curl-devel':
			ensure => installed,
			name => $operatingsystem ? {
				Centos => 'libcurl-devel',
				Debian => 'libcurl4-openssl-dev',
			};
	}
	
	case $operatingsystem {
		Centos: {realize(Exec['extract_redmine'], File['/etc/redmine', '/etc/redmine/default', 'redmine_source'])}
		Debian: {realize(Package['redmine-mysql'])}
	}

	@package { 'redmine-mysql':
		ensure => installed,
		require => Package['redmine'],
	}

	@exec {
		'extract_redmine':
			path => '/bin:/usr/bin',
			cwd => '/usr/share',
			provider => shell,
			command => 'tar xzvf redmine-1.2.1.tar.gz && mv redmine{-1.2.1,}',
			require => File['/usr/share/redmine-1.2.1.tar.gz'],
			creates => '/usr/share/redmine';
	}

	@file {
		'/etc/redmine':
			ensure => directory,
			owner => root,
			group => root,
			mode => 0755,
			before => File['/etc/redmine/default'];

		'/etc/redmine/default':
			ensure => directory,
			owner => $redmine_id,
			group => $redmine_id,
			mode => 0755,
			before => Class['redmine::config'];
#			require => Exec['redmine_sources'],

		'redmine_source':
			ensure => present,
			path => '/usr/share/redmine-1.2.1.tar.gz',
			source => 'puppet:///modules/redmine/redmine-1.2.1.tar.gz';

	}
}
