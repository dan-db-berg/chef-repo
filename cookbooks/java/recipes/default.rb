remote_file "/tmp/jdk-7u79-linux-x64.rpm" do
   source "https://s3.amazonaws.com/my-cf-elb-logs/jdk-7u79-linux-x64.rpm"
end

rpm_package 'jdk-7u79-linux-x64.rpm' do
	source "/tmp/jdk-7u79-linux-x64.rpm"
	action :install
end
