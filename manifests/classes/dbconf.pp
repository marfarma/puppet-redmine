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
}
