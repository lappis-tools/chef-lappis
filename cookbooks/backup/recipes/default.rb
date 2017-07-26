script_dir = "/usr/bin/backup-cleaner.sh"
crontab_dir = "/etc/cron.d/root"

cookbook_file script_dir do
  source 'backup-cleaner.sh'
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
  command 'chmod 0777 /usr/bin/backup-cleaner.sh'
end

template '/usr/bin/services_backup' do
  mode '755'
end

template '/usr/bin/portal_fs_backup' do
  mode '755'
end

file '/var/log/portal_backup.log'
file '/var/log/portal_fs_backup.log'
file '/var/log/codeschool.log'
file '/var/log/unbgames.log'

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

directory '/var/backups/codeschool' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/var/backups/unbgames' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
