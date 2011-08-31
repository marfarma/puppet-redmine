define redmine::plugin (
	$name,
	$url,
	$plugin_dir = "$redmine::home/vendor/plugins"
) {
	exec {
		"git_pull_$name":
			command => "git clone $url $name",
			cwd => "$plugin_dir";
	}
}
