define redmine::plugin (
	$name,
	$url,
	$plugin_dir = "$redmine::home/vendor/plugins",
	$deps = [],
	$gems = []
) {
	exec {
		"git_pull_$name":
			command => "git clone $url $name",
			cwd => "$plugin_dir",
			creates => "$plugin_dir/$name";
#			require => Package["deps_$name", "gems_$name"];

		"install_plugin_$name":
			command => 'rake db:migrate_plugins',
			cwd => "$redmine::home",
			environment => 'RAILS_ENV=production',
			require => Exec["git_pull_$name"];
	}

	@package {
		$deps:
			ensure => present;
		$gems:
			provider => gem,
			ensure => present;
	}

	if $deps != [] {
		realize(Package[$deps])
	}

	if $gems != [] {
		realize(Package[$gems])
	}
}
