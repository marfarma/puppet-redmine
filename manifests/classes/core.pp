class redmine::core {
	exec {
		'session_store':
			path => '/bin:/usr/bin:/opt/ruby/bin',
			cwd => '/usr/share/redmine/public',
			provider => 'shell',
			command => 'rake generate_session_store',
			require => Package['gem_rails'];
	}
}
