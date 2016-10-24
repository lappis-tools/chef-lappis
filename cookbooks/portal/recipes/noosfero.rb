#
# Cookbook Name:: portal
# Recipe:: noosfero
#

cookbook_file '/etc/apt/sources.list.d/noosfero.list'
template '/etc/apt/sources.list.d/lappis.list' # Source for portal-theme
execute 'apt-get update'

user 'noosfero'

# This dependency is missing on Noosfero package
package 'openssl'

2.times do
  package 'noosfero' do
    version '1.5.2'
    options '--force-yes --fix-missing'
    ignore_failure true
  end
end

package 'portal-unb-theme' do
  action :upgrade
end

template '/etc/noosfero/database.yml' do
  group 'noosfero'
  mode '0640'
end

service 'noosfero' do
  action [:enable, :start]
end
