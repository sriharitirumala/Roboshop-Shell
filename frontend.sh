code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
  }
  
print_head "Installing nginx"
yum install nginx -y &>>${log_file}

print_head "Removing nginx"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading nginx"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Unzipping nginx"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying nginx"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "Restarting nginx"
systemctl restart nginx &>>${log_file}


}