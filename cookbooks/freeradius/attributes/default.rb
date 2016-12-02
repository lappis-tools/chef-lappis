#
# Cookbook Name:: freeradius
# Attributes:: default
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

# Global options
default['freeradius']['version_3'] = true
default['freeradius']['use_ldap'] = true
default['freeradius']['local_secret'] = 'lappistest'
default['freeradius']['remote_clients'] = { 'lappis': '10.0.2.2' }
default['freeradius']['remote_secret'] = 'lappistest'

# Platform-specific options
case node['platform_family']
when 'debian'
  default['freeradius']['conf_dir'] = '/etc/freeradius'
  default['freeradius']['user'] = 'freerad'
  default['freeradius']['group'] = 'freerad'
  default['freeradius']['service'] = 'freeradius'
when 'rhel'
  default['freeradius']['conf_dir'] = '/etc/raddb'
  default['freeradius']['user'] = 'radiusd'
  default['freeradius']['group'] = 'radiusd'
  default['freeradius']['service'] = 'radiusd'
end
