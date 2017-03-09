######### INSTALL LAMP

yum_package 'httpd'

service 'httpd.service' do
  action [:enable,:start]
end

yum_package ['mariadb-server','mariadb']

service 'mariadb' do
  action :start
end

#TODO - Verify it's correct or not
#TODO - It demands a password. If i am logged in as root, it would be necessary?
#TODO - Should i use execute or script command?
execute 'install_mysql' do
  command 'mysql_secure_installation'
end

service 'mariadb.service' do
  action :enable
end

yum_package ['php','php-mysql']

service 'httpd.service' do
  action :restart
end

########INSTALL NAGIOS

yum_package ['gcc','glibc','glibc-common','gd','gd-devel','make','net-snmp','openssl-devel','xinetd','unzip']

user 'nagios'

group 'nagcmd' do
  action [:create,:modify]
  members 'nagios'
  append true
end

remote_file 'var/nagios_packages/nagios-4.1.1.tar.gz' do
  source 'https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz'
  action :create_if_missing
end

execute 'extract_nagios_files' do
  command 'tar xzvf nagios-4.1.1.tar.gz'
  cwd '/var/nagios_packages/'
end

execute 'configure_nagios' do
  command './configure --with-command-group=nagcmd'
  cwd '/var/nagios_packages/nagios-4.1.1'
end

execute 'compile_install_nagios' do
  command 'make all && make install && make install-commandmode && make install-init && make install-config && make install-webconf'
  cwd '/var/nagios_packages/nagios-4.1.1'
end

execute 'add_web_server_user' do
  command 'usermod -G nagcmd apache'
end

remote_file 'var/nagios_packages/nagios-plugins-2.1.1.tar.gz' do
  source 'http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz'
  action :create_if_missing
end

execute 'extract_nagios_plugin_files' do
  command 'tar xzvf nagios-plugins-2.1.1.tar.gz'
  cwd '/var/nagios_packages/'
end

execute 'configure_nagios_plugins' do
  command './configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl'
  cwd '/var/nagios_packages/nagios-plugins-2.1.1'
end

execute 'compile_install_nagios_plugins' do
  command 'make && make install'
  cwd '/var/nagios_packages/nagios-4.1.1'
end

