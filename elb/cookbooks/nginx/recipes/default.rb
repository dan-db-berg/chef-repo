package "nginx.x86_64" do
      action :install
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

file '/etc/nginx/conf.d/default.conf' do
  content 'server {
       listen         80;
       server_name    sync.msv-a.net;
       return         301 https://$server_name$request_uri;
}

server {
listen  443;
ssl on;

server_name sync.msv-a.net;
root /usr/share/tomcat/webapps/intuit/;

  location / {
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:8080/intuit/;
  }
}'
end

bash "certificates_copy" do
  code <<-EOL
  cp /home/ec2-user/chef-repo/elb/cookbooks/nginx/files/* /etc/ssl/
  EOL
end

service "nginx" do
  action [:enable, :start]
end
