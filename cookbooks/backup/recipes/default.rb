script_dir = "/usr/bin/noosfero-backup.sh"
crontab_dir = "/var/spool/cron/crontabs/root"

cookbook_file script_dir do
  source 'noosfero-backup.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create 
end

cookbook_file crontab_dir do
  source 'root'
  owner 'root'
  group 'root'
  mode '600'
  action :create
end

#Check permission before execute this step - TODO
execute 'grants_permission_noosfero' do
  command 'chmod 755 /usr/bin/noosfero-backup.sh'
end

template '/usr/bin/portal_backup' do
  mode '755'
end

template '/usr/bin/portal_fs_backup' do
  mode '755'
end

file '/var/log/portal_backup.log'
file '/var/log/portal_fs_backup.log'

directory '/var/backups/portal' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/var/backups/portal_fs' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
