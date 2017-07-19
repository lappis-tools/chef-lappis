execute 'update_packages' do
  command 'apt-get update'
end

package 'wget'
package 'openssh-server'
package 'vim'
package 'silversearcher-ag'
package 'git'
package 'curl'
package 'libjpeg-dev'
package 'nginx'

execute 'Clone UnBGames repository into /var/local/' do
  command 'git clone https://github.com/fga-gpp-mds/2017.1-PlataformaJogosUnB.git'
  cwd '/var/local/'
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/gunicorn_start.sh' do
  source 'gunicorn_start.sh'
end

cookbook_file '/etc/systemd/system' do
  source 'gunicorn.service'
  mode '755'
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
end

service 'nginx' do
  action :restart
end

cookbook_file '/home/root/.profile' do
  source 'profile'
end

execute 'reloading profile file' do
  command 'source /home/root/profile'
end
