#
# Cookbook Name:: freeradius
# Recipe:: ldap
#
# Copyright (C) 2013-2014 Continuuity, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install package
package 'freeradius-ldap' do
  action :install
end

unless node['freeradius']['version_3']
  # Install module template
  template "#{node['freeradius']['conf_dir']}/modules/ldap" do
    source 'modules/ldap.erb'
    mode '0644'
    owner 'root'
    group 'root'
    action :create
    notifies :restart, 'service[freeradius]'
  end
else
  # Install module template
  template "#{node['freeradius']['conf_dir']}/mods-available/ldap" do
    source 'mods-available/ldap.erb'
    mode '0644'
    owner 'root'
    group node['freeradius']['group']
    action :create
    notifies :restart, 'service[freeradius]'
  end

  link "#{node['freeradius']['conf_dir']}/mods-enabled/ldap" do
    to "#{node['freeradius']['conf_dir']}/mods-available/ldap"
    owner 'root'
    group node['freeradius']['group']
  end
end

