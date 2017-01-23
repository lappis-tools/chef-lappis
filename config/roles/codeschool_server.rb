name "codeschool_server" 
description "Install and configure Codeschool server"

run_list *[
	"recipe[basics]"
]
