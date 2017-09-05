package "httpd.x86_64" do
      action :install
end

file '/etc/httpd/conf/httpd.conf' do
  action :delete
end

template "workers.properties" do
  path "/etc/httpd/conf/workers.properties"
  source "workers.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "mod_jk.so" do
  path "/etc/httpd/modules/mod_jk.so"
  source "mod_jk.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "httpd" do
  action [:enable, :start]
end
