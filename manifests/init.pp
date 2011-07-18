import 'pre.pp'
import 'depends.pp'
import 'core.pp'
import 'config.pp'

class redmine {
	include redmine::pre
	include redmine::depends
	include redmine::core
	include redmine::config
}
