package 'postgresql'
package 'libpq-dev'

pjunb_user = 'pjunb'
root_user = 'root'

template '/etc/postgresql/9.4/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0644
  variables({
    user_app: pjunb_user,
    user_dev: root_user
  })
end

service 'postgresql' do
  action [:enable, :start]
end

execute "creating postgres' users for #{pjunb_user}" do
  psql_command = "CREATE USER #{pjunb_user} with createdb login password 'pjunb'"
  command "psql -U postgres -c #{ '"' + psql_command + '"' }"
  user 'postgres'
  ignore_failure true
end

execute "creating postgres' users for #{root_user}" do
  psql_command = "CREATE USER #{root_user} with createdb login password 'root'"
  command "psql -U postgres -c #{ '"' + psql_command + '"' }"
  user 'postgres'
  ignore_failure true
end

execute 'install_psycopg2' do
  command 'pip3 install psycopg2'
end

service 'postgresql' do
  action [:restart]
end

execute 'create database for pjunb' do
  command 'psql -U postgres -c "CREATE DATABASE unbgames OWNER pjunb"'
  user 'postgres'
  ignore_failure true
end

cookbook_file '/root/.profile' do
  source 'profile'
end
