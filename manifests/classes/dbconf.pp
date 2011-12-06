class redmine::dbconf {
	mysql_user {
		$redmine::dbuser:
			pass => $redmine::dbpass;
	}

	mysql_db {
		$redmine::production_db:
			user => $redmine::dbuser,
			pass => $redmine::dbpass;

		$redmine::devel_db:
			user => $redmine::dbuser,
			pass => $redmine::dbpass;
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
