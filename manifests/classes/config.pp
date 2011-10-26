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

		'email.yml':
			ensure => present,
			owner => $redmine_id,
			group => $redmine_id,
			path => "$redmine::home/config/email.yml",
			content => template('redmine/email.yml.erb');

		'/var/www':
			ensure => directory;

		'/var/www/redmine':
			ensure => link,
			target => "$redmine::home/public",
			owner => $redmine_id,
			group => $redmine_id;
	}

	exec {
		'config_redmine_mysql_bootstrap':
			environment => 'RAILS_ENV=production',
			path => "$ruby::bin_dir",
			cwd => "$redmine::home",
			provider => shell,
			command => 'rake db:migrate',
			require => Mysql_db[$redmine::production_db],
			notify => Service["$redmine::webserver"];

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
}
