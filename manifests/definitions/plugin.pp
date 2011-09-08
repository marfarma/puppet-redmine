define redmine::plugin (
	$name,
	$url,
	$plugin_dir = "$redmine::home/vendor/plugins",
	$deps = [],
	$gems = []
) {
	exec {
		"install_plugin_$name":
			command => "ruby script/plugin install $url",
			cwd => "$redmine::home",
			creates => "$plugin_dir/$name";

		"db:migrate_plugin_$name":
			command => 'rake db:migrate_plugins',
			cwd => "$redmine::home",
			environment => 'RAILS_ENV=production',
			require => Exec["install_plugin_$name"];
	}

	@package {
		$deps:
			ensure => present,
			before => Exec["install_plugin_$name"];
		$gems:
			provider => gem,
			ensure => present,
			before => Exec["install_plugin_$name"];
	}

	if $deps != [] {
		realize(Package[$deps])
	}

	if $gems != [] {
		realize(Package[$gems])
	}
}
