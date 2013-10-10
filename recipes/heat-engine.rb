#
# Cookbook Name:: heat
# Recipe:: heat-engine
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

platform_options["heat_engine_package_list"].each do |pkg|
  package pkg do
    action node["osops"]["do_package_upgrades"] == true ? :upgrade : :install
    options platform_options["package_overrides"]
  end
end

include_recipe "heat::heat-common"

service platform_options["heat_engine_service"] do
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, "template[/etc/heat/heat.conf]", :delayed
end

# Add a monit process for heat
include_recipe "monit::server"

# matching a process name
monit_procmon platform_options["heat_engine_service"] do
  process_name platform_options["heat_engine_service"]
  start_cmd "service #{platform_options["heat_engine_service"]} start"
  stop_cmd "service #{platform_options["heat_engine_service"]} stop"
end