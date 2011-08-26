class redmine::dbconf {
	mysql_user {
		$dbuser:
			pass => $dbpass;
	}

	mysql_db {
		$production_db:
			user => $dbuser,
			pass => $dbpass;

		$devel_db:
			user => $dbuser,
			pass => $dbpass;
	}
}
