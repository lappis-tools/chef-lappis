name "backup_client"
description "Install and configure backup lappis at VM in any infrastructure"

run_list *[
  'recipe[basics]',
  'recipe[backup]'
]

