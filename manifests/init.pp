import 'pre.pp'
import 'core.pp'
import 'config.pp'
import 'depends.pp'

class redmine {
	include redmine::pre
	include redmine::depends
	include redmine::core
	include redmine::config
}
