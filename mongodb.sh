source common.sh

print_head "Setup mongodb repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "Update mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf &>>${log_file}

print_head "Enable mongodb"
systemctl enable mongod &>>${log_file}

print_head "Start mongodb"
systemctl restart mongod &>>${log_file}


