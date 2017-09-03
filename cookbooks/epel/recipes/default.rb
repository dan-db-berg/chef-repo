remote_file "/tmp/epel-release-6-8.noarch.rpm" do
   source "http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

rpm_package 'epel-release-6-8.noarch.rpm' do
	source "/tmp/epel-release-6-8.noarch.rpm"
	action :install
end
