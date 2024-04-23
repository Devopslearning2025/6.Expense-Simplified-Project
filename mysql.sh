#!/bin/bash

echo "Enter the DB Password"
read -s mysql_password

check_user

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling MYSQL"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting MySQL"

#mysql -h 172.31.24.255 -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
mysql -h db.devopslearning2025.online -uroot -p${mysql_password} -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_password} &>>$LOGFILE
    VALIDATE $? "setting root password of MySQL"
else
    echo -e "MySQL passowrd already set ....$Y SKIPPING  $N"
fi  