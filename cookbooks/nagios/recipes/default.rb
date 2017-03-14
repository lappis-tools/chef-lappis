#TODO add password to root at passwd file, this is needed in 'mysql_secure_installation' script execution

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

execute 'pip install pexpect' do
  command 'pip install pexpect'
end

python 'run mysql_secure_installation' do
  code <<-EOH
import pexpect
import sys
from time import sleep

child = pexpect.spawn('/bin/bash', ['-c', 'mysql_secure_installation'])
child.logfile = sys.stdout

child.expect('.*Enter current password for root [(]enter for none[)]:.*')
child.sendline('')

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

remote_file '/var/nagios_packages/nrpe-2.15/nrpe-2.15.tar.gz' do
  source 'http://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz'
  action :create_if_missing
end

execute 'extract_nrpe_files' do
  command 'tar xvf nrpe-2.15.tar.gz'
  cwd '/var/nagios_packages/'
end

execute 'configure_nrpe' do
  command './configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu'
  cwd '/var/nagios_package/nrpe-2.15'
end

execute 'build_and_install_nrpe' do
  command 'make all && make install && make install-xinetd && make install-daemon-config'
  cwd '/var/nagios_package/nrpe-2.15'
end

execute 'restart xinetd' do
  commnad 'service xinetd restart'
end
