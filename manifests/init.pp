import "pre.pp"
import "install.pp"
import "config.pp"

class redmine {
	include redmine::pre
	include redmine::install
	include redmine::config
}
