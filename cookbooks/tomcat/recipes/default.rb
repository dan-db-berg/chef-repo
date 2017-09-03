package "tomcat.noarch" do
      action :install
end

service "tomcat" do
  action [:enable, :start]
end

directory "/usr/share/tomcat/webapps/intuit" do
  mode 0755
  owner 'root'
  group 'tomcat'
  action :create
end

file '/usr/share/tomcat/webapps/intuit/index.html' do
  content 'Hello Intutit'
  owner 'root'
  group 'tomcat'
end


service "tomcat" do
  action :restart
end
