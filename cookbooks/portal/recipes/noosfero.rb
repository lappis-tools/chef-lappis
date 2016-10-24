#
# Cookbook Name:: portal
# Recipe:: noosfero
#

cookbook_file '/etc/apt/sources.list.d/noosfero.list'
template '/etc/apt/sources.list.d/lappis.list' # Source for portal-theme
execute 'apt-get update'

user 'noosfero'

package 'noosfero' do
  version '1.6.0'
  options '--force-yes --fix-missing'
  ignore_failure true
end

package 'portal-unb-theme' do
  options '--allow-unauthenticated'
  action :upgrade
end

template '/etc/noosfero/database.yml' do
  group 'noosfero'
  mode '0640'
end

service 'noosfero' do
  action [:enable, :start]
end

# Needed Plugins for Portal FGA
plugins = [
  'custom_forms',
  'html5_video',
  'people_block',
  'statistics',
  'video',
  'work_assignment'
]

execute 'plugins:enable' do
  command "/usr/share/noosfero/script/noosfero-plugins enable #{plugins.join(' ')}"
end
