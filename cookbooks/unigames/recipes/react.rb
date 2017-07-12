## Node and npm installation and configuration

execute 'create dir /var/chef' do
  command 'mkdir /var/chef'
  ignore_failure true
end

execute 'set ppa for node' do
  command 'curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh'
  cwd '/var/chef'
end

execute 'run nodesource_setup.sh script' do
  command 'bash nodesource_setup.sh'
  cwd '/var/chef'
end

execute 'install node from ppa' do
  command 'apt-get install nodejs'
end

python 'install build-essential' do
  code <<-EOH
import pexpect
import sys
child = pexpect.spawn('/bin/bash', ['-c', 'apt-get install build-essential'])
child.logfile = sys.stdout
child.expect('.*Do you want to continue?.*')
child.sendline('Y')
  EOH
  ignore_failure true
end

python 'install libssl-dev' do
  code <<-EOH
import pexpect
import sys
child = pexpect.spawn('/bin/bash', ['-c', 'apt-get install libssl-dev'])
child.logfile = sys.stdout
child.expect('.*Do you want to continue?.*')
child.sendline('Y')
  EOH
  ignore_failure true
end
