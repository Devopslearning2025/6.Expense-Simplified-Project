#!/bin/bash

source ./common-code.sh
check_user

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx  &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting the nginx"

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "Dowling the frontend file"

cd /usr/share/nginx/html
rm -rf /usr/share/nginx/html/* 
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting the zip file"

cp /home/ec2-user/Project-Automation/expense.conf /etc/nginx/default.d/expense.conf

systemctl restart nginx&>>$LOGFILE
VALIDATE $? "Restarting the nginx"