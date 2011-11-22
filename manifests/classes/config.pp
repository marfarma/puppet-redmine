class redmine::config {
	file {
		'database.yml':
			ensure => present,
			owner => $apache::user,
			group => $apache::group,
			path => $::operatingsystem ? {
				default => '/usr/share/redmine/config/database.yml',
				Debian => '/etc/redmine/default/database.yml',
			},
			content => template("redmine/database.yml.erb");

		'configuration.yml':
			ensure => present,
			owner => $apache::user,
			group => $apache::group,
			path => "$redmine::home/config/configuration.yml",
			content => template('redmine/configuration.yml.erb');
	}

	exec {
		'chown redmine':
			command => "chown -R ${apache::user}:${apache::group} ${redmine::home}",
			provider => shell;
	}

	if $::operatingsystem == 'archlinux' {
		exec {
			'include redmine.conf':
				command => 'echo -e "\n# Redmine config\nInclude conf/extra/redmine.conf" >> /etc/httpd/conf/httpd.conf',
				require => File['apache.conf'];
		}
	}

	vhost {
		'redmine':
			documentroot => "${redmine::home}/public",
			insecure => no,
			ssl => on,
			servername => "${redmine::servername}",
			serveralias => "${redmine::serveralias}";
	}
}
