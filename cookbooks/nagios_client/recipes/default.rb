execute 'run apt-get update' do
  command 'apt-get update'
end

package ['nagios-plugins', 'nagios-nrpe-server']

ruby_block 'get host ip with shell' do
  block do
    host_ip = "/sbin/ifconfig wlan0| grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'"
  end
end

#TODO change the false ip to host_ip variable
execute 'adding ip host to allowed_hosts' do
  command 'sed -i "s/allowed_hosts=127.0.0.1\$/allowed_hosts=127.0.0.1, 10.0.0.5/" /etc/nagios/nrpe.cfg'
end

ruby_block 'get filesystem with shell' do
  block do
    filesystem = "df -h / | grep '^/dev' | awk ' {print $1} '"
  end
end

ruby_block 'get filesystem with shell' do
  block do
    filesystem = "df -h / | grep '^/dev' | awk ' {print $1} '"
  end
end

#TODO change /dev/vda ti filesystem variable
execute 'change the filesystem in command[check_hda1]' do
  command "sed -i 's/\/dev\/hda1/\/dev\/vda/g' /etc/nagios/nrpe.cfg"
end

sevice 'nagios-nrpe-server' do
  action :restart
end
