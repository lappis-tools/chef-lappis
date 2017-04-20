name "unigames_server"
description "Install and configure Unigames"

run_list *[
  'recipe[unigames::basics]',
  'recipe[unigames::database]'
]
