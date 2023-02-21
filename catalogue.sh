source common.sh

print_head  "configure nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}

print_head "Create User roboshop"
useradd roboshop &>>${log_file}

print_head "Create Application Directory to roboshop"
mkdir /app &>>${log_file}

print_head "Delete old content"
rm -rf /app/* &>>${log_file}

print_head "Download the app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "extracting content"
unzip /tmp/catalogue.zip &>>${log_file}

print-head "installing nodejs"
npm install &>>${log_file}

print-head "copy systemD service files"
cp configs/catalogue.service etc/systemd/system/catalogue.service &>>${log_file}

print-head "reload catalogue"
systemctl daemon-reload &>>${log_file}

print-head "enabling catalogue"
systemctl enable catalogue &>>${log_file}

print_head "restarting catalogue"
systemctl restart catalogue &>>${log_file}

print_head "copying mongodb repo file"
cp configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "installing mongodb"
yum install mongodb-org-shell -y &>>${log_file}

mongo --host mongodb.devopsb71service.site </app/schema/catalogue.js &>>${log_file}
