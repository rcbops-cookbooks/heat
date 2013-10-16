#
# Cookbook Name:: heat
# Recipe:: heat-api-cfn-ssl
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apache2"
include_recipe "apache2::mod_wsgi"
include_recipe "apache2::mod_rewrite"
include_recipe "osops-utils::mod_ssl"
include_recipe "osops-utils::ssl_packages"

# set the service name
service_name = node["heat"]["platform"]["cfn_api_service"]

# Remove monit file if it exists
if node.attribute?"monit"
  if node["monit"].attribute?"conf.d_dir"
    file "#{node['monit']['conf.d_dir']}/#{service_name}.conf" do
      action :delete
      notifies :reload, "service[monit]", :immediately
    end
  end
end

# setup wsgi file
directory "#{node["apache"]["dir"]}/wsgi" do
  action :create
  owner "root"
  group "root"
  mode "0755"
end

wsgi_path = "#{node["apache"]["dir"]}/wsgi/#{service_name}-wsgi.py"

template wsgi_path do
  source "mod_wsgi.py.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
    :service => "heat.api.cfn",
    :name => "heat_api_cfn"
  )
end

# Drop a VHOST file
api_name = "cfn_api"
bind_info = get_bind_endpoint("heat", api_name)
srvs = node["heat"]["services"][api_name]

template value_for_platform(
  ["ubuntu", "debian", "fedora"] => {
    "default" => "#{node["apache"]["dir"]}/sites-available/#{service_name}"
  },
  "fedora" => {
    "default" => "#{node["apache"]["dir"]}/vhost.d/#{service_name}"
  },
  ["redhat", "centos"] => {
    "default" => "#{node["apache"]["dir"]}/conf.d/#{service_name}"
  },
  "default" => {
    "default" => "#{node["apache"]["dir"]}/#{service_name}"
  }
) do
  source "modwsgi_vhost.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :listen_ip => bind_info["host"],
    :service_port => bind_info["port"],
    :cert_file => srvs["cert_location"],
    :key_file => srvs["key_location"],
    :wsgi_file  => wsgi_path,
    :workers => node["heat"]["services"][api_name]["workers"],
    :proc_group => api_name,
    :log_file => "/var/log/heat/heat.log"
  )
  notifies :reload, "service[apache2]", :delayed
end

apache_site service_name do
  enable true
  notifies :restart, "service[apache2]", :immediately
end