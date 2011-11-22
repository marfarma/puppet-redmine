class redmine::core {
	exec {
		'selinux_permissive':
			path => '/bin:/usr/bin:/usr/sbin',
			command => 'setenforce permissive',
			unless => 'cat /etc/selinux/config|grep "SELINUX=disabled"',
			onlyif => 'which setenforce';

		'session_store':
			path => '/bin:/usr/bin:/opt/ruby/bin',
			cwd => '/usr/share/redmine/public',
			provider => 'shell',
			command => 'rake generate_session_store',
			require => Package['gem_rails'];
	}
}
