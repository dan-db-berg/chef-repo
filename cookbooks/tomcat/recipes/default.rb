remote_file "/tmp/apache-tomcat-7.0.67.zip" do
	source "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.zip"
end

bash "unpack_tomcat" do
	code <<-EOL
	unzip /tmp/apache-tomcat-7.0.67.zip -d /opt/
	mv /opt/apache-tomcat-7.0.67 /opt/tomcat/
	chown -R tomcat:tomcat /opt/tomcat/
	chmod 0755 /opt/tomcat/bin/*.sh
	EOL
end

user 'tomcat' do
  manage_home true
  home '/home/tomcat'
  shell '/bin/bash'
end

template "tomcat" do
  path "/etc/init.d/tomcat"
  source "tomcat.erb"
  owner "root"
  group "root"
  mode "0755"
end

service "tomcat" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [ :enable, :start ]
    subscribes :restart, "template[tomcat]", :immediately
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
