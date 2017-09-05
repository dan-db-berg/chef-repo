remote_file "/tmp/apache-tomcat-7.0.67.zip" do
        source "https://s3.amazonaws.com/cf-soft/apache-tomcat-7.0.67.zip"
end

package "unzip.x86_64" do
      action :install
end

user 'tomcat' do
  manage_home true
  home '/home/tomcat'
  shell '/bin/bash'
end

bash "unpack_tomcat" do
        code <<-EOL
        unzip /tmp/apache-tomcat-7.0.67.zip -d /opt/
        mv /opt/apache-tomcat-7.0.67 /opt/tomcat/
        EOL
end

bash "tomcat_permissions" do
        code <<-EOL
        chown -R tomcat:tomcat /opt/tomcat/
        chmod 0755 /opt/tomcat/bin/*.sh
        EOL
end

template "tomcat" do
  path "/etc/init.d/tomcat"
  source "tomcat.erb"
  owner "root"
  group "root"
  mode "0755"
end

directory "/opt/tomcat/webapps/intuit" do
  mode 0755
  owner 'tomcat'
  group 'tomcat'
  action :create
end

file '/opt/tomcat/webapps/intuit/index.html' do
  content 'Hello Intutit'
  owner 'tomcat'
  group 'tomcat'
end

service "tomcat" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [ :enable, :start ]
    subscribes :restart, "template[tomcat]", :immediately
end
