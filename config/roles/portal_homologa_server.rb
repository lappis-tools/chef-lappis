name "portal_homologa_server"
description "Install and configure Portal Homologa Server"

run_list *[
  'recipe[postgresql::service]',
  'recipe[portal::database]',
  'recipe[portal::noosfero]',
]
