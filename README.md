Support
=======

Issues have been disabled for this repository.
Any issues with this cookbook should be raised here:

[https://github.com/rcbops/chef-cookbooks/issues](https://github.com/rcbops/chef
-cookbooks/issues)

Please title the issue as follows:

[heat]: \<short description of problem\>

In the issue description, please include a longer description of the issue, alon
g with any relevant log/command/error output.
If logfiles are extremely long, please place the relevant portion into the issue
description, and link to a gist containing the entire logfile

Please see the [contribution guidelines](CONTRIBUTING.md) for more information about contributing to this cookbook.

Description
===========

Installs the OpenStack Heat service from packages

Requirements
============

Chef 11 or higher

Platform
--------

* CentOS >= 6.3
* Ubuntu >= 12.04

Cookbooks
---------

The following cookbooks are dependencies:

* database
* keystone
* monitoring
* mysql
* openssl
* osops-utils
* keepalived

Resources/Providers
===================

None


Recipes
=======

heat-common
-------
- Installs common packages and sets up config file

heat-setup
-----
- Sets up database, config files and keystone config
- Handles keystone registration and glance database creation

heat-api
------
- Installs the heat-api server

heat-api-cloudwatch
------
- Installs the heat-api-cloudwatch server

heat-api-cfn
------
- Installs the heat-api-cfn server


Attributes
==========

* `heat["db"]["name"]` = "heat"
* `heat["db"]["username"]` = "heat"
* `heat["service_tenant_name"]` = "service"
* `heat["service_user"]` = "heat"
* `heat["service_role"]` = "admin"
* `heat["services"]["api"]["scheme"]` = "http"

* `heat["services"]["api"]["cloudwatch-host"]` = osops-network on which to run the api
* `heat["services"]["api"]["cloudwatch-port"]` = 8000
* `heat["services"]["api"]["cloudwatch-backlog"]` = 4096
* `heat["services"]["api"]["cloudwatch-cert"]` = None
* `heat["services"]["api"]["cloudwatch-key"]` = None
* `heat["services"]["api"]["cloudwatch-workers"]` = 10

* `heat["services"]["api"]["cfn-host"]` = osops-network on which to run the api
* `heat["services"]["api"]["cfn-port"]` = 8003
* `heat["services"]["api"]["cfn-backlog"]` = 4096
* `heat["services"]["api"]["cfn-cert"]` = None
* `heat["services"]["api"]["cfn-key"]` = None
* `heat["services"]["api"]["cfn-workers"]` = 10

* `heat["services"]["api"]["host"]` = osops-network on which to run the api
* `heat["services"]["api"]["port"]` = 8004
* `heat["services"]["api"]["backlog"]` = 4096
* `heat["services"]["api"]["cert"]` = None
* `heat["services"]["api"]["key"]` = None
* `heat["services"]["api"]["workers"]` = 10

* `heat["services"]["api"]["path"]` = "/"
* `heat["syslog"]["use"]` = true
* `heat["syslog"]["facility"]` = "LOG_LOCAL3"
* `heat["logging"]["debug"]` = "false"
* `heat["logging"]["verbose"]` = "false"

Templates
=========

* `heat.conf.erb` - rsyslog config file for glance

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)  
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)  
Author:: Ron Pedde (<ron.pedde@rackspace.com>)  
Author:: Joseph Breu (<joseph.breu@rackspace.com>)  
Author:: William Kelly (<william.kelly@rackspace.com>)  
Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)  
Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)  
Author:: Matt Thompson (<matt.thompson@rackspace.co.uk>)  
Author:: Andy McCrae (<andrew.mccrae@rackspace.co.uk>)  
Author:: Kevin Carter (<kevin.carter@rackspace.com>)  

Copyright 2012-2013, Rackspace US, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
