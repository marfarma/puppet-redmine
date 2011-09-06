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
	}

	if $redmine::plugins != [] {
		realize(Redmine::Plugin[$redmine::plugins])
	}
}
