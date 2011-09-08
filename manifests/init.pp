import 'classes/*'
import 'definitions/*'

class redmine (
	$webserver = 'httpd',
	$production_db = 'redmine_production',
	$devel_db = 'redmine_devel',
	$dbuser = 'redmine',
	$dbpass = 'redmine',
	$stages = 'no',
	$home = '/usr/share/redmine',
	$plugins = [],
	$mail_user = 'redmine',
	$mail_pass = 'redmine',
	$mail_auth = 'plain',
	$mail_domain = 'redmine.org',
	$mail_port = '587',
	$mail_smtp = 'smtp.redmine.org',
	$mail_tls = 'true',
	$themes
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
				before => Class['redmine::plugins'];
			'redmine::plugins':;
			'redmine::themes':;
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
			'redmine::plugins':
				require => Class['redmine::config'],
				stage => config;
			'redmine::themes':
				stage => config;
		}
	}

    Exec{path=>'/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'}
}
