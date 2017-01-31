name "backup_server"
description "Install and configure backup_lappis at VM in CPD infrastructure"

run_list *[
  'recipe[basics]',
  'recipe[backup]'
]

