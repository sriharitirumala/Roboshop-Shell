source common.sh

print_head "Setup mongodb repository"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install mongodb"
yum install mongodb-org -y

print_head "Enable mongodb"
systemctl enable mongod

print_head "Start mongodb"
systemctl start mongod

#update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0

