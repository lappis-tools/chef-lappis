#TODO add password to root at passwd file, this is needed in 'mysql_secure_installation' script execution
#TODO add password to nagios' admin user at passed file, its needed at line 189 
#TODO fix email to be replaced, at line 176

######### INSTALL LAMP

yum_package 'httpd'

service 'httpd.service' do
  action [:enable,:start]
end

yum_package ['mariadb-server','mariadb']

service 'mariadb' do
  action :start
end

#Install pip expect to use on mysql configuration

yum_package 'python-pip'

execute 'pip_install_pexpect' do
  command 'pip install pexpect'
end

python 'run mysql_secure_installation' do
  code <<-EOH
import pexpect
import sys
import yaml
from time import sleep

database_root_password = ''

child = pexpect.spawn('/bin/bash', ['-c', 'mysql_secure_installation'])
child.logfile = sys.stdout

child.expect('.*Enter current password for root [(]enter for none[)]:.*')
child.sendline(database_root_password)

child.expect('.*Set root password?.*')
child.sendline('n')

child.expect('.*Remove anonymous users?.*')
child.sendline('n')

child.expect('.*Disallow root login remotely?.*')
child.sendline('n')

child.expect('.*Remove test database and access to it?.*')
child.sendline('n')

child.expect('.*Reload privilege tables now?.*')
child.sendline('Y')
  EOH
end

#TODO - Verify it's correct or not
#TODO - It demands a password. If i am logged in as root, it would be necessary?
#TODO - Should i use execute or script command?

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

directory '/var/nagios_packages' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file '/var/nagios_packages/nagios-4.1.1.tar.gz' do
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

remote_file '/var/nagios_packages/nagios-plugins-2.1.1.tar.gz' do
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

#Install NRPE

remote_file '/var/nagios_packages/nrpe-2.15.tar.gz' do
  source 'http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz'
  action :create_if_missing
end

execute 'extract_nrpe_files' do
  command 'tar xvf nrpe-2.15.tar.gz'
  cwd '/var/nagios_packages/'
end

execute 'configure_nrpe' do
  command './configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu'
  cwd '/var/nagios_packages/nrpe-2.15'
end

execute 'build_and_install_nrpe' do
  command 'make all && make install && make install-xinetd && make install-daemon-config'
  cwd '/var/nagios_packages/nrpe-2.15'
end

execute 'add_nagios_server_ip' do
  command 'sed -i "s/\(\s\+only_from\s\+= 127.0.0.1\)\$/\1 10.0.0.145/" /etc/xinetd.d/nrpe'
end

execute 'restart xinetd' do
  command 'service xinetd restart'
end

## Configure Nagios

execute 'uncomment_nagios_config_line' do
  command 'sed -i "s/#cfg_dir=\/usr\/local\/nagios\/etc\/servers/cfg_dir=\/usr\/local\/nagios\/etc\/servers/" /usr/local/nagios/etc/nagios.cfg'
end

directory '/usr/local/nagios/etc/servers' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'replace_email' do
  command 'sed -i "s/\(\s\+email\s\+\)nagios@localhost/\1meuemail@teste/" /usr/local/nagios/etc/objects/contacts.cfg'
end

cookbook_file '/usr/local/nagios/etc/objects/commands.cfg' do
  source 'commands.cfg'
  owner 'root'
  group 'root'
  mode  '0644'
end

## Configure Apache

python 'create_nagios_admin_user' do
  code <<-EOH
import pexpect
import sys
import yaml
from time import sleep

nagios_admin_password = ''

child = pexpect.spawn('/bin/bash', ['-c', 'htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin'])
child.logfile = sys.stdout

child.expect('.*New password:.*')
child.sendline(nagios_admin_password)

child.expect('.*Re-type new password:.*')
child.sendline(nagios_admin_password)
  EOH
end

cookbook_file '/etc/systemd/system/nagios.service' do
  source 'nagios.service'
  owner 'root'
  group 'root'
  mode  '0644'
end

execute 'enable_nagios_service' do
  command 'systemctl enable /etc/systemd/system/nagios.service'
end

execute 'start_nagios' do
  command 'systemctl start nagios'
end

execute 'restart_nagios' do
  command 'systemctl restart nagios'
end

execute 'start_nagios_service' do
  command 'systemctl start nagios.service'
end

execute 'restart_apache_service' do
  command 'systemctl restart httpd.service'
end

execute 'enable_nagios_to_start_on_boot' do
  command 'chkconfig nagios on'
end
