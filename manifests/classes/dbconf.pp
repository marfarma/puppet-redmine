class redmine::dbconf {
	mysql_user {
		$redmine::dbuser:
			pass => $redmine::dbpass,
			host => "${redmine::dbhost}";
	}

	mysql_db {
		$redmine::production_db:
			user => $redmine::dbuser,
			host => "${redmine::dbhost}";

		$redmine::devel_db:
			user => $redmine::dbuser,
			host => "${redmine::dbhost}";
	}

	exec {
		'config_redmine_mysql_bootstrap':
			environment => 'RAILS_ENV=production',
			path => "$ruby::bin_dir",
			cwd => "$redmine::home",
			provider => shell,
			command => 'rake db:migrate',
			require => Mysql_db[$redmine::production_db],
			notify => Service["$apache::apache"];
	}
}
