#
# Cookbook Name:: freeradius
# Attributes:: ldap
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

# These are the defaults, shipped with the freeradius package on CentOS
default['freeradius']['ldap']['server'] = '10.0.0.160'
default['freeradius']['ldap']['basedn'] = 'dc=ldap,dc=lappis,dc=rocks'
default['freeradius']['ldap']['filter'] = '(uid=%{%{Stripped-User-Name}:-%{User-Name}})'
default['freeradius']['ldap']['password_attribute'] = '1234'
