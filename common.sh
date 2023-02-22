code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}


print_head() {
  echo -e "\e[36m$1\e[0m"
  }


status_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "read the log file ${log_file} for more info about error
    exit 1"
  fi
}

NODEJS(){
  print_head  "Configure NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  print_head "Create user roboshop"
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
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  cd /app
  status_check $?

  print_head "Extracting content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Installing NodeJS dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Copy systemD service files"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "reload ${component}"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "enabling ${component}"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "restarting ${component}"
  systemctl restart ${component} &>>${log_file}
  status_check $?

  print_head "copying mongodb repo file"
  cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  status_check $?

  print_head "installing mongodb client"
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "load schema"
  mongo --host mongodb.devopsb71services.site </app/schema/${component}.js &>>${log_file}
  status_check $?
}