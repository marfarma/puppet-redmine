define redmine::plugin (
	$name,
	$url,
	$plugin_dir = "$redmine::home/vendor/plugins",
	$deps = '',
	$gems = ''
) {
	exec {
		"git_pull_$name":
			command => "git clone $url $name",
			cwd => "$plugin_dir",
			creates => "$plugin_dir/$name";
#			require => Package["deps_$name", "gems_$name"];

		"install_plugin_gitosis":
			command => 'rake db:migrate_plugins',
			cwd => "$redmine::home",
			environment => 'RAILS_ENV=production',
			require => Exec["git_pull_$name"];
	}

# this should split an array - but it doesn't :(
# $gems_array = split($gems, ',')

	@package {
		"deps_$name":
			name => $deps,
			ensure => present;
		"gems_$name":
			name => $gems,
			provider => gem,
			ensure => present;
	}

	if $deps != '' {
		realize(Package["deps_$name"])
	}

	if $gems != '' {
		realize(Package["gems_$name"])
	}
}
