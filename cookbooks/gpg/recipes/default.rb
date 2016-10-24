gpg_opts = ''
# Everything runs if the machine doesn't have a key
unless system("sudo -u #{node['gpg']['user']} -i gpg --list-keys | grep \"#{node['gpg']['name_real']}\"")
  package 'haveged'

  service 'haveged' do
    action :start
  end

  template node['gpg']['batch_conf']

  execute 'gpg:generate' do
    command "sudo -u #{node['gpg']['user']} -i gpg #{gpg_opts} --gen-key --batch #{node['gpg']['batch_conf']}"
  end

  service 'haveged' do
    action :stop
  end
end

