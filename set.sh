#!/bin/bash
set -e

falilure(){
    echo "Line number: $1 , Command:$2"
}
trap '"${LINENO}" "$BASH_COMMAND"' ERR


source ./common-code.sh
check_user

echo "Enter the DB Password"
read -s mysql_password

dnf install mysql-server -y &>>$LOGFILE
systemctl enable mysqld &>>$LOGFILE
systemctl start mysqld &>>$LOGFILE

#mysql -h 172.31.24.255 -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
mysql -h db.devopslearning2025.online -uroot -p${mysql_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_password} &>>$LOGFILE
else
    echo -e "MySQL passowrd already set ....$Y SKIPPING  $N"
fi