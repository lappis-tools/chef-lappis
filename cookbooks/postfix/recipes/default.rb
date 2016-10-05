#
# Cookbook Name:: postfix
# Recipe:: default
#

package 'postfix'
service 'postfix'

cookbook_file '/etc/postfix/main.cf' do
  notifies :restart, 'service[postfix]'
end
