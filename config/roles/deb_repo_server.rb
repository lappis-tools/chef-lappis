name 'deb_repo'
description 'Instal and configure a Debian package repository'

run_list *[
  'recipe[basics]',
  'recipe[gpg]',
  'recipe[reprepro]',
]

