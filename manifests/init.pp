import 'pre.pp'
import 'depends.pp'
import 'core.pp'
import 'config.pp'

class redmine (
	$webserver = 'httpd',
	$production_db = 'redmine_production',
	$devel_db = 'redmine_devel',
	$dbuser = 'redmine',
	$dbpass = 'redmine',
	$stages = 'no'
) {
	if $stages == 'no' {
		class{'redmine::pre':} -> class{'redmine::depends':} -> class{'redmine::core':} -> class{'redmine::dbconf') -> class{'redmine::config':}
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
