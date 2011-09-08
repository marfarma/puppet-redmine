class redmine::plugins {
	@redmine::plugin {
		'gitolite':
			name => 'gitolite',
#			url => 'https://github.com/ivyl/redmine-gitolite.git',
#			url => 'https://github.com/ericpaulbishop/redmine_git_hosting.git',
			url => 'https://github.com/DarwinAwardWinner/redmine_git_hosting.git',
			gems => ['lockfile', 'inifile', 'net-ssh'];

		'gitosis':
			name => 'redmine_gitosis',
			url => 'https://github.com/y8/redmine-gitosis.git',
			gems => ['lockfile', 'inifile', 'net-ssh'];

		'gravatar-helper':
			name => 'gravatar-helper',
			url => 'http://mattmccray.com/svn/rails/plugins/gravatar_helper';

		'bulk time entry':
			name => 'bulk time entry',
			url => 'https://github.com/edavis10/redmine-bulk_time_entry_plugin.git';

		'pastebin':
			name => 'pastebin',
			url => 'git://github.com/commandprompt/redmine_pastebin.git';

		'dmfs':
			name => 'dmfs',
			url => 'http://redmine-dmsf.googlecode.com/svn/';

		'http_auth':
			name => 'redmine_http_auth',
			url => 'https://github.com/AdamLantos/redmine_http_auth.git';

		'kanban':
			name => 'redmine_kanban',
			url => 'https://github.com/edavis10/redmine_kanban.git';

		'timesheet':
			name => 'redmine_timesheet',
			url => 'https://github.com/edavis10/redmine-timesheet-plugin.git';

		'webdav':
			name => 'redmine_webdav',
			url => 'https://github.com/amartel/redmine_webdav.git',
			require => Redmine::Plugin['http_auth'];

		'schedules':
			name => 'redmine_schedules',
			url => 'https://github.com/bradbeattie/redmine-schedules-plugin.git',
			gems => ['holidays'];
	}

	if $redmine::plugins != [] {
		realize(Redmine::Plugin[$redmine::plugins])
	}
}
