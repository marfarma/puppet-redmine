class redmine::config {
	file {
		'database.yml':
			ensure => present,
			owner => $redmine_id,
			group => $redmine_id,
			path => $::operatingsystem ? {
				default => '/usr/share/redmine/config/database.yml',
				Debian => '/etc/redmine/default/database.yml',
			},
			content => template("redmine/database.yml.erb");

		'configuration.yml':
			ensure => present,
			owner => $redmine_id,
			group => $redmine_id,
			path => "$redmine::home/config/configuration.yml",
			content => template('redmine/configuration.yml.erb');

		'/var/www':
			ensure => directory;

		'/var/www/redmine':
			ensure => link,
			target => "$redmine::home/public",
			owner => $redmine_id,
			group => $redmine_id;
	}

	exec {
		'chown redmine':
			command => "chown -R $redmine_id:$redmine_id $redmine::home",
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
			documentroot => '/var/www/redmine',
			insecure => no,
			ssl => on,
			servername => "${redmine::servername}",
			serveralias => "${redmine::serveralias}";
	}
}
