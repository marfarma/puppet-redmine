class redmine::plugins {
	@redmine::plugin {
		'gitosis':
			name => 'redmine_gitosis',
			url => 'https://github.com/DarwinAwardWinner/redmine_git_hosting.git',
			gems => ['lockfile', 'inifile', 'net-ssh'];
	}

	if $plugins != '' {
		realize(Redmine::Plugin[$redmine::plugins])
	}

/*
	class gitosis {

	$gems_array = ['inifile', 'lockfile', 'net-ssh']

		package {
			$gems_array:
				ensure => present,
				provider => gem;
		}

		realize(Redmine::Plugin["gitosis"])
	}
*/
}
