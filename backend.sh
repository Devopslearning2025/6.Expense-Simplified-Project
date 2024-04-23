#!/bin/bash

source ./common-code.sh
check_user
echo "Enter DB password"
read -s "mysql_password"

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Dsiabled nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabled nodejs:20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "install nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "user created"
else
    echo -e "User is already there .... $Y SKIPPING $N"
fi    

mkdir -p /app &>>$LOGFILE
VALIDATE $? "directory is created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "download is completed"

cd /app 
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "extracted backend.zip is completed"

npm install &>>$LOGFILE
VALIDATE $? "npm dependices install completed"

cp /home/ec2-user/simplified-project/backend.service /etc/systemd/system/backend.service  &>>$LOGFILE
VALIDATE $? "copied backend.servce"

systemctl daemon-reload  &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl start backend  &>>$LOGFILE
VALIDATE $? "started backend"

systemctl enable backend  &>>$LOGFILE
VALIDATE $? "enabled backend"

dnf install mysql -y  &>>$LOGFILE
VALIDATE $? "installed mysql client"

mysql -h db.devopslearning2025.online -uroot -p${mysql_password} < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "schema loaded"

systemctl restart backend  &>>$LOGFILE
VALIDATE $? "restarted backend"