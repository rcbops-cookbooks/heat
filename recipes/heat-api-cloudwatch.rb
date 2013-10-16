#
# Cookbook Name:: heat
# Recipe:: heat-api-cloudwatch
#
# Copyright 2013, Rackspace US, Inc.
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

platform_options = node["heat"]["platform"]

platform_options["cloudwatch_api_package_list"].each do |pkg|
  package pkg do
    action node["osops"]["do_package_upgrades"] == true ? :upgrade : :install
    options platform_options["package_overrides"]
  end
end

include_recipe "heat::heat-common"

service platform_options["cloudwatch_api_service"] do
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, "template[/etc/heat/heat.conf]", :delayed
end

# Drop The Default Alarm File in our Templates.
cookbook_file "/etc/heat/templates/AWS_CloudWatch_Alarm.yaml" do
  source "AWS_CloudWatch_Alarm.yaml.erb"
  owner "heat"
  group "heat"
  mode "0644"
end

heat_api_cloudwatch = get_bind_endpoint("heat", "cloudwatch_api")

# Setup SSL
if heat_api_cloudwatch["scheme"] == "https"
  include_recipe "heat::heat-api-cloudwatch-ssl"
else
  # Add a monit process for heat
  include_recipe "monit::server"

  # matching a process name
  monit_procmon platform_options["cloudwatch_api_service"] do
    process_name platform_options["cloudwatch_api_service"]
    start_cmd "service #{platform_options["cloudwatch_api_service"]} start"
    stop_cmd "service #{platform_options["cloudwatch_api_service"]} stop"
  end

  if node.recipe?"apache2"
    apache_site platform_options["cloudwatch_api_service"] do
      enable false
      notifies :restart, "service[apache2]", :immediately
    end
  end
end
