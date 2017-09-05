package "httpd.x86_64" do
      action :install
end

file '/etc/httpd/conf/httpd.conf' do
  action :delete
end

bash "copy_apache_file" do
        code <<-EOL
	sudo cp /home/ec2-user/chef-repo/elb/cookbooks/apache/templates/httpd.conf /etc/httpd/conf/
	sudo cp /home/ec2-user/chef-repo/elb/cookbooks/apache/templates/workers.properties /etc/httpd/conf/
	sudo cp /home/ec2-user/chef-repo/elb/cookbooks/apache/templates/mod_jk.so /etc/httpd/modules/
        EOL
end

service "httpd" do
  action [:enable, :start]
end
