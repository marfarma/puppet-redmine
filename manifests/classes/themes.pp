class redmine::themes {
	@redmine::theme {
		'pepper':
			url => 'https://github.com/koppen/redmine-pepper-theme.git';

		'aurora':
			url => 'https://github.com/jorgebg/redmine-aurora-theme.git';

		'innerboard':
			url => 'https://github.com/huacnlee/redmine-theme-innerboard.git';
	}

	if $redmine::themes {
		realize(Redmine::Theme[$redmine::themes])
	}
}
