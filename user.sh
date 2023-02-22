source common.sh

print_head  "Configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create User roboshop"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
 useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Create Application Directory to roboshop"
if [ ! -d /app ]; then
 mkdir /app &>>${log_file}
fi
status_check $?

print_head "Delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Download the app content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
cd /app
status_check $?

print_head "Extracting content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy systemD service files"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "reload user"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enabling user"
systemctl enable user &>>${log_file}
status_check $?

print_head "restarting user"
systemctl restart user &>>${log_file}
status_check $?

print_head "copying mongodb repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "installing mongodb client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema"
mongo --host mongodb.devopsb71services.site </app/schema/user.js &>>${log_file}
status_check $?