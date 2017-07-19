package 'python3-pip'
package 'python-pip'

# Verify
execute 'update pip3' do
  command 'easy_install3 -U pip'
end

execute 'install pexpect' do
  command 'pip install pexpect'
end

execute 'install Django requirements' do
  command 'pip3 install -r requirements.txt'
  cwd '/var/local/2017.1-PlataformaJogosUnB/backend'
end

execute 'install_gunicorn' do
  command 'pip3 install gunicorn'
end

execute 'restarting gunicorn' do 
  command 'service gunicorn restart'
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/settings.py' do
  action :delete
  not_if "ls /var/local/2017.1-PlataformaJogosUnB/backend/core/settings.py"
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/settings.py' do
  source 'settings.py'
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/wsgi.py' do
  action :delete
  not_if "ls /var/local/2017.1-PlataformaJogosUnB/backend/core/wsgi.py"
end

cookbook_file '/var/local/2017.1-PlataformaJogosUnB/backend/core/wsgi.py' do
  source 'wsgi.py'
end
