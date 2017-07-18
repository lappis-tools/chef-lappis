name "unbgames_server"
description "Install and configure unbgames"

run_list *[
  'recipe[unbgames::default]',
  'recipe[unbgames::django]',
  'recipe[unbgames::react]',
  'recipe[unbgames::database]'
]
