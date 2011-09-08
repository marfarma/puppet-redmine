define redmine::theme (
	url
) {
	exec {
		'install_theme':
			command => "git clone $url $name",
			cwd => "$redmine::home/public/themes";
	}
}
