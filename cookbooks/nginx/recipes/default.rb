package 'nginx'

template '/etc/nginx/sites-available/default' do
  mode 644
end

service 'nginx' do
  action :restart
end
