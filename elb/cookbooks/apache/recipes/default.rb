package "httpd.x86_64" do
      action :install
end

template "workers.properties" do
  path "/etc/httpd/conf/"
  source "workers.properties.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "httpd.conf" do
  path "/etc/httpd/conf/"
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "mod_jk.so" do
  path "/etc/httpd/modules/"
  source "mod_jk.so.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "httpd" do
  action [:enable, :start]
end
