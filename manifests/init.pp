import 'classes/*'
import 'definitions/*'

class redmine (
	$webserver = 'httpd',
	$production_db = 'redmine_production',
	$devel_db = 'redmine_devel',
	$dbuser = 'redmine',
	$dbpass = 'redmine',
	$stages = 'no',
	$home = '/usr/share/redmine'
) {
	if $stages == 'no' {
		class{
			'redmine::pre':
				before => Class['redmine::depends'];
			'redmine::depends':
				before => Class['redmine::core'];
			'redmine::core':
				before => Class['redmine::dbconf'];
			'redmine::dbconf':
				require => Service['mysqld'],
				before => Class['redmine::config'];
			'redmine::config':
		}
	} else {
		class {
			'redmine::pre':
				stage => pre;
			'redmine::depends':
				stage => depends,
				require => Class['ruby'];
			'redmine::core':
				stage => core;
			'redmine::dbconf':
				stage => config;
			'redmine::config':
				stage => config;
		}
	}
}
