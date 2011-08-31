class redmine::plugins {
	@redmine::plugin {
		'gitosis':
			name => 'redmine_gitosis',
			url => 'https://github.com/DarwinAwardWinner/redmine_git_hosting.git',
			gems => ['lockfile', 'inifile', 'net-ssh'];
	}

	if $redmine::plugins != '' {
		realize(Redmine::Plugin[$redmine::plugins])
	}
}
