class redmine_conf {

	$production_db="redmine_production"
	$development_db="redmine_development"
	$redmine_db_user="redmine"
	$redmine_db_pass="redmine"

	file { 'database.yml':
		ensure => present,
		owner => $redmine_id,
		group => $redmine_id,
		path => $operatingsystem ? {
			Debian => '/etc/default/database.yml',
			Centos => '/usr/share/redmine/config/database.yml',
		},
		require => $operatingsystem ? {
			Debian => Package['redmine'],
			Centos => Exec['redmine_centos'],
		},
		content => template("database.yml.erb"),
	}
}
