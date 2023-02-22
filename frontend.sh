source common.sh


print_head "Installing nginx"
yum install nginx -y &>>${log_file}

print_head "Removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading frontend"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Unzipping nginx for roboshop"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying nginx configs"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "starting nginx"
systemctl restart nginx &>>${log_file}
