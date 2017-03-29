name "lappis_page_server"
description "Install dependencies and configure lappis page's service"

run_list *[
  'recipe[lappispage]'
]
