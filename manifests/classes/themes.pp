class redmine::themes {
	@redmine::theme {
		'pepper':
			url => 'https://github.com/koppen/redmine-pepper-theme.git';
	}

	if $redmine::themes {
		realize(Redmine::Theme[$redmine::themes])
	}
}
