remote_file "/tmp/jdk-7u79-linux-x64.tar.gz" do
        source "https://s3.amazonaws.com/my-cf-elb-logs/jdk-7u79-linux-x64.tar.gz"
end

bash "unpack_java" do
        code <<-EOL
        tar -xvzf /tmp/jdk-7u79-linux-x64.tar.gz  -C /opt/
	mv /opt/jdk1.7.0_79/ /opt/java/
	EOL
end
