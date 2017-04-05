execute 'run apt-get update' do
  command 'apt-get update'
end

package 'nagios-plugins'
package 'nagios-nrpe-server'

execute 'adding ip host to allowed_hosts' do
  command "sed -i 's/allowed_hosts=127.0.0.1\$/allowed_hosts=127.0.0.1,"\
          "#{node['peers']['nagios-client']}/' /etc/nagios/nrpe.cfg"
end

filesystem = `df -h / | grep '^/dev' | awk ' {print $1} '`
filesystem = filesystem.gsub(/\//, "\\/")
filesystem = filesystem.strip

#TODO change /dev/vda ti filesystem variable
execute 'change the filesystem in command[check_hda1]' do
	command 'sed -i "s/\/dev\/hda1/%{filesystem}/g" /etc/nagios/nrpe.cfg' % {filesystem: filesystem}
end

service 'nagios-nrpe-server' do
  action :restart
end
