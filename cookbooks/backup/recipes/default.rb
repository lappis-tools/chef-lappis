script_dir = "/usr/bin/services-backup"
crontab_dir = "/etc/cron.d/root"

cookbook_file script_dir do
  source 'services-backup'
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
  command 'chmod 0777 /usr/bin/services-backup.sh'
end

template '/usr/bin/portal_backup' do
  mode '755'
end

template '/usr/bin/portal_fs_backup' do
  mode '755'
end

template '/usr/bin/codeschool_backup' do
  mode '755'
end

file '/var/log/portal_backup.log'
file '/var/log/portal_fs_backup.log'
file '/var/log/codeschool.log'

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
