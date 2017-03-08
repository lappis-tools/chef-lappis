name "nagios_server"
description "Install and configure Nagios Server"

run_list *[
  'recipe[nagios]'
]

