import "install.pp"
import "config.pp"

class redmine {
	include redmine::install
	include redmine::config
}
