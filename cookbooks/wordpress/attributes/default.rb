default["mysql"]["server_root_password"] = "chaefa6iGh7oux8dei3f"
default["mysql"]["server_debian_password"] = "Thie4Xae2zoh7caich5u"
default["mysql"]["server_repl_password"] = "mieroo8Fie2loo7cai6y"
default["wordpress"]["db_host"] = "localhost"
default["wordpress"]["database"] = "wordpressdb"
default["wordpress"]["db_username"] = "wpuser"
default["wordpress"]["db_password"] = "aingohC4iequo6fahnge"
default["wordpress"]["path"] = "/var/www/wordpress"
default["wordpress"]["wp_title"] = "wordpress"
default["wordpress"]["wp_admin"] = "admin"
default["wordpress"]["wp_admin_email"] = "admin@somewhere.org"
default["wordpress"]["wp_admin_password"] = "ic7Wezael6janaephi"
default["wordpress"]["theme"] = ""

# Set default hostname to cloud public DNS if exists

if ( ! node['cloud'].nil? ) && ( ! node['cloud']['public_hostname'].nil? )
  default['wordpress']['server_name']=node.cloud.public_hostname
else
  default['wordpress']['server_name']='localhost'
end

if ( node['wordpress']['server_name'].empty? )
  set['wordpress']['server_name']=nil
end
