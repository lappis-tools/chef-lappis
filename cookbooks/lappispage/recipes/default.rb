#TODO Change password
execute 'update packages' do
  command 'apt-get update'
end

package 'ruby'
package 'git'

execute 'install bundler' do
  command 'gem install bundler'
end

packages =  %w(postgresql postgresql-contrib libpq-dev)

packages.each do |p|
  package p
end

user = 'lappis'

template '/etc/postgresql/9.4/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0644
  variables({
   user: user
  })
end

service 'postgresql' do
  action [:enable, :start]
end

execute "creating postgres users for #{user}" do
  psql_command = "\"CREATE USER #{user} with createdb login password 'lappis'\""
  command "psql -U postgres -c #{psql_command}"
  user 'postgres'
  ignore_failure true
end

execute 'clone repository' do
  command 'git clone http://gitlab.com/pedrodelyra/lappis.git'
  ignore_failure  true
end

cookbook_file '/lappis/config/database.yml'

execute 'update dependencies' do
  command 'bundle install'
  cwd '/lappis'
end

execute 'create database' do
  command 'rake db:create'
  cwd '/lappis'
end

execute 'migrate database' do
  command 'rake db:migrate'
  cwd '/lappis'
end

### Create lappis page service file

template 'etc/init.d/lappispage' do
  source 'lappispage/lappispage.erb'
  mode '0755'
  variables({
    service_port: node.lappispage.initd.port
  })
end

cookbook_file '/lib/systemd/system/lappispage.service' do
  owner 'root'
  group 'root'
  mode '0644'
end

service 'lappispage' do
  action [:start, :enable]
end
