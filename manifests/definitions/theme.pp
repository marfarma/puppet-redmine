define redmine::theme (
	url
) {
	exec {
		"install_theme_$name":
			command => "git clone $url $name",
			cwd => "$redmine::home/public/themes";
	}
}
