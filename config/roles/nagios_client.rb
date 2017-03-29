name "squid_server"
description "Install and configure proxy cache squid service"

run_list *[
  'recipe[nagios_client]'
]
