# Recipe to install and configure nginx and letsencrypt

execute 'apt-get update'

packages = %w(nginx git bc)

packages.each do |a|
  package a
end

git '/opt/letsencrypt' do
  repository 'https://github.com/letsencrypt/letsencrypt'
  action :sync
end

cookbook_file '/etc/nginx/sites-available/default' do
  source 'nginx-default-config'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'remove server files' do
  command 'rm *-server'
  cwd '/etc/nginx/sites-enabled/'
end

service 'nginx' do
  action :restart
end

file '/etc/lappis.services' do
  action :create_if_missing
end

crt_domains = "-d #{node['crt_domains']['default']['server_name']}"
node['crt_domains'].each do |key, value|
  crt_domains += " -d #{value['server_name']}" unless key == 'default'
end

ruby_block 'Check current cert domains' do
  block do
    services = YAML.load_file('/etc/lappis.services')
    if node['crt_domains'] != services
      # Creating backup to the last certificates
      system('sudo rm -rf /etc/letsencrypt/live/lappis.rocks.bak')
      system('sudo mv /etc/letsencrypt/live/lappis.rocks /etc/letsencrypt/live/lappis.rocks.bak')
      # Genereting new certificates
      system("/opt/letsencrypt/letsencrypt-auto certonly -a webroot --renew-by-default --email lappis.unb@gmail.com\
             --webroot-path=/var/www/html #{crt_domains} --agree-tos --non-interactive")
      File.open('/etc/lappis.services','w'){ |f| f.write node['crt_domains'].to_hash.to_yaml }
      system("sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048")

      unless File.exists?('/etc/letsencrypt/live/lappis.rocks')
        system('sudo mv /etc/letsencrypt/live/lappis.rocks.bak /etc/letsencrypt/live/lappis.rocks')
      end
    end
  end
end

cookbook_file '/etc/nginx/sites-available/default' do
  source 'nginx-ssl-config'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'nginx' do
  action :restart
end
