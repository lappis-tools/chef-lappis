package 'ruby'
package 'git'

package ['postgresql','postgresql-contrib','libpq-dev']

lappis_user = 'lappis'

execute "creating postgres users for #{lappis_user}" do
  psql_command = "\"CREATE USER #{lappis_user} with createdb login password '#{node['passwd']['postgresql']}'\""
  command "psql -U postgres -c #{psql_command}"
  user 'postgres'
  ignore_failure true
end

service 'postgresql' do
  action [:enable, :start]
end

execute 'clone repository' do
  command 'git clone http://gitlab.com/pedrodelyra/lappis.git'
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
