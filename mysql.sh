source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mmissing mysql root password\e[0m"
  exit 1
fi

mysql

print_head "Disabling Mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "copy mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enabling mysql server"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Starting mysql server"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set root password"
echo shows databases | mysql -uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?


