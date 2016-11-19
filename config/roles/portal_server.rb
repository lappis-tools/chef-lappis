name "portal_server"
description "Install and configure Portal"

run_list *[
  'recipe[postfix::portal_email]',
  'recipe[postgresql::service]',
  'recipe[portal::database]',
  'recipe[portal::noosfero]',
  'recipe[portal::backup]',
]
