#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "mysql::ruby"

["unzip", "wget", "curl" ].each do |pkg|
  package pkg do
    action :install
  end
end

apache_site "default" do
  enable true
end

mysql_database node['wordpress']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['wordpress']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['wordpress']['db_password']
  database_name node['wordpress']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

execute "wp-cli_install" do
  command "curl http://wp-cli.org/installer.sh | bash"
  creates "~/.composer/bin/wp"
  action :run
end

directory node['wordpress']['path'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "wp-cli_download_wordpress" do
  cwd node['wordpress']['path']
  command "~/.composer/bin/wp core download"
  creates node['wordpress']['path'] + "wp-settings.php"
end

execute "wp-cli_configure_db" do
  command "~/.composer/bin/wp core config --dbname=#{node["wordpress"]["database"]} --dbuser=#{node["wordpress"]["db_username"]} dbpass=#{node['wordpress']['db_password']} --dbhost=#{node["wordpress"]["db_host"]}"
  action :run
end

#wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"
#remote_file wordpress_latest do
#  source "http://wordpress.org/latest.tar.gz"
#  mode "0644"
#end


#execute "untar-wordpress" do
#  cwd node['wordpress']['path']
#  command "tar --strip-components 1 -xzf " + wordpress_latest
#  creates node['wordpress']['path'] + "/wp-settings.php"
#end

#if ( !node["wordpress"]["theme"].nil? )
#  wp_theme = Chef::Config[:file_cache_path] + "/theme.zip"
#  execute "unzip-theme" do
#    cwd ::File.join(node['wordpress']['path'], "wp-content", "themes")
#    command "unzip " + wp_theme
#    action :nothing
#  end
#  remote_file wp_theme do
#    source node["wordpress"]["theme"]
#    mode "0644"
#    notifies :run, "execute[unzip-theme]", :immediately
#  end
  
#  wp_theme_name = ::File.basename(node["wordpress"]["theme"]).split(".")[0]
#  mysql_database "enable theme" do
#    connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
#    database_name node["wordpress"]["theme"]
#    sql <<EEND
#       UPDATE wp_options SET option_value = '#{wp_theme_name}' WHERE option_name IN ('template', 'stylesheet', 'current_theme');
#EEND
#    action :query
#end

#wp_secrets = Chef::Config[:file_cache_path] + '/wp-secrets.php'

#remote_file wp_secrets do
#  source 'https://api.wordpress.org/secret-key/1.1/salt/'
#  action :create_if_missing
#  mode 0644
#end

#salt_data = ''
#ruby_block 'fetch-salt-data' do
#  block do
#    salt_data = File.read(wp_secrets)
#  end
#  action :create
#end

#template node['wordpress']['path'] + '/wp-config.php' do
#  source 'wp-config.php.erb'
#  mode 0755
#  owner 'root'
#  group 'root' 
#  variables(
#    :database        => node['wordpress']['database'],
#    :user            => node['wordpress']['db_username'],
#    :password        => node['wordpress']['db_password'],
#    :wp_secrets      => salt_data)
#end

#web_app 'wordpress' do
#  template 'site.conf.erb'
#  docroot node['wordpress']['path']
#  server_name node['wordpress']['server_name']
#end
