package 'docker'

cookbook_file "/lib/systemd/system/codeschool.service" do
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/init.d/codeschool" do
  owner "root"
  group "root"
  mode "0644"
end

execute "Change codeschool permition" do
  user "root"
  command "chmod a+x /etc/init.d/codeschool"
end

execute "Updaterc.d codeschool" do
  user "root"
  command "update-rc.d codeschool defaults"
end

execute "Codeschool start" do
  command "systemctl restart codeschool"
end

execute "Enable codeschool" do
  command "systemctl enable codeschool"
end
