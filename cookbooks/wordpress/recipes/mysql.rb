#
## Cookbook Name:: wordpress
## Recipe:: mysql
##
## Copyright 2013, Cometera
##
## All rights reserved - Do Not Redistribute
##
include_recipe "mysql::client"
include_recipe "mysql::ruby"

mysql_database node['wordpress']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['wordpress']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  host node['wordpress']['app_host']
  password node['wordpress']['db_password']
  database_name node['wordpress']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

