package "tomcat.noarch" do
      action :install
end

file '/etc/tomcat/server.xml' do
  action :delete
end

file '/etc/tomcat/server.xml' do
content '<!-- Tomcat listen on 8080 -->
<Connector port="8080" protocol="HTTP/1.1"
     connectionTimeout="20000"
     URIEncoding="UTF-8"
     redirectPort="8443" />


  <!-- Set /intuit as default path -->
  <Host name="localhost"  appBase="webapps"
       unpackWARs="true" autoDeploy="true">

         <Context path="" docBase="intuit">
             <!-- Default set of monitored resources -->
             <WatchedResource>WEB-INF/web.xml</WatchedResource>
         </Context>

  </Host>'
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
  action [:enable, :start]
end
