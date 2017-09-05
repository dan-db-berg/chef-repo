#!/bin/bash

stack_name=$1

aws_path="/root/.local/bin"
cf_json=CF-$stack_name.json
user="ec2-user"
user_home="/home/$user/"
s3_path="https://s3.amazonaws.com/cf-soft/"
chef_rpm="chefdk-2.1.11-1.el6.x86_64.rpm"
chef_repo="https://github.com/dan-db-berg/chef-repo.git"
key="/root/usnv2.pem"


cloudformation () {
wget -o /tmp/$cf_std_json "'$s3_path''$cf_json'"
$aws_path/aws cloudformation create-stack --stack-name $stack_name --template-body file://$cf_json --parameters ParameterKey=KeyName,ParameterValue=usnv ParameterKey=HostedZone,ParameterValue=msv-a.net
}

cf_std_instance_data () {
cf_host=`$aws_path/aws cloudformation describe-stacks --stack-name $stack_name | grep OutputValue | awk 'NR==1 {print $2}'|tr -d '"'`
}

cf_elb_instance_data () {
cf_elb_host=`$aws_path/aws cloudformation describe-stacks --stack-name $stack_name | grep OutputValue |awk 'NR>=2 && NR<=3 { print $2 }'|tr -d '()'|tr -d '"'`
}

chef_init () {
ssh -i $key -o "StrictHostKeyChecking no" $user@$cf_host "(sudo yum install wget git -y; sudo wget '$s3_path''$chef_rpm'; sudo rpm -ivh $user_home/$chef_rpm; sudo git clone $chef_repo; sudo chef-solo -c $user_home/chef-repo/$stack_name/solo.rb)"
}

elb_chef_init () {
for cf_host in $cf_elb_host
do
chef_init
done
}

if [ "$stack_name" == "std" ]
then
	cloudformation
	sleep 120
	cf_std_instance_data
	chef_init
elif [ "$stack_name" == "elb" ]
then
        cloudformation
        sleep 120
	cf_elb_instance_data
	elb_chef_init
elif [ -z "$stack_name" ]
then
	echo "Please use: 'std' or 'elb' as param"
	exit
fi
