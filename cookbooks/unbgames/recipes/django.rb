execute 'update_packages' do
  command 'apt-get update'
end

package 'python3-pip'
package 'python-pip'

execute 'pip_install_pexpect' do
  command 'pip install pexpect'
end

execute 'install Django requirements'
  command 'pip3 install -r requirements.txt'
  cwd '/var/local/2017.1-PlataformaJogosUnB/backend'
end

execute 'install_gunicorn' do
  command 'pip3 install gunicorn'
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/settings.py' do
  action :delete
  source 'settings.py'
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/wsgi.py' do
  action :delete
  source 'wsgi.py'
end
