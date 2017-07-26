#
# Cookbook Name:: unbgames
# Recipe:: backup
#
#
# Settings up backup routine
#

cookbook_file '/usr/bin/unbgames_backup' do
  source 'unbgames_backup'
  mode '755'
end

cookbook_file '/usr/bin/clean_unbgames_backup' do
  source 'clean_unbgames_backup'
  mode '755'
end

file '/var/log/unbgames_backup.log'
cookbook_file '/etc/cron.d/unbgames_backup_routine'

