code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}


print_head() {
  echo -e "\e[32m$1\e[0m"
  }
