source common.sh

print_head  "Configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJS"
yum install NodeJS -y &>>${log_file}

print_head "Create User roboshop"
useradd roboshop &>>${log_file}

print_head "Create Application Directory to roboshop"
mkdir /app &>>${log_file}

print_head "Delete old content"
rm -rf /app/* &>>${log_file}

print_head "Download the app content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting content"
unzip /tmp/catalogue.zip &>>${log_file}

print-head "Installing NodeJS"
npm install &>>${log_file}

print-head "Copy systemD service files"
cp ${code_dir}/configs/catalogue.service etc/systemd/system/catalogue.service &>>${log_file}

print-head "reload catalogue"
systemctl daemon-reload &>>${log_file}

print-head "enabling catalogue"
systemctl enable catalogue &>>${log_file}

print_head "restarting catalogue"
systemctl restart catalogue &>>${log_file}

print_head "copying mongodb repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

print_head "installing mongodb client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "load schema"
mongo --host mongodb.devopsb71service.site </app/schema/catalogue.js &>>${log_file}

