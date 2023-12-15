#!/bin/bash

ID=$(id -u)

time=$(date +%d-%H-%M)

log_file_path=/tmp/$0-$time.log

echo "script started at $time " &>>log_file_path

if [ $ID -ne 0 ]
then
    echo "Mate you need to have root access, Permission Denied"
else
    echo "You have access to install"
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo "$2.... Failed"
        
    else
        echo "$2....Succes"
    fi
}

dnf module disable nodejs -y &>>log_file_path

validate $? "Disabling default version of nodejs"

dnf module enable nodejs:18 -y &>>log_file_path

validate $? " Enabling nodejs-18V "

dnf install nodejs -y &>>log_file_path

validate $? " Installing nodejs package"

id roboshop &>>log_file_path

if [ $? -ne 0 ]
then
    useradd roboshop
    validate $? "adding roboshop user"
else
    echo " roboshop user alredy exists" &>>log_file_path
fi

mkdir -p /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>log_file_path

validate $? "Downloading user  code"

cd /app

unzip /tmp/user.zip &>>log_file_path

validate $? "Unzipping code in /tmp/user.zip directory"

cp /home/centos/roboshop-shell/service.user /etc/systemd/system/user.service &>>log_file_path

validate $? "copying service.user to user.service"

systemctl daemon-reload &>>log_file_path

validate $? "Re-loading deamon" 

systemctl enable user &>>log_file_path

validate $? "Enabling user service" 

systemctl start user &>>log_file_path

validate $? "starting user service"

cp /home/centos/roboshop-shell/mongorepo /etc/yum.repos.d/mongo.repo

validate $? "copying mongo repo to yum.repo file"

dnf install mongodb-org-shell -y &>>log_file_path

validate $? "installing mongodb-shell"

mongo --host mongodb.174a9.online </app/schema/user.js &>>log_file_path

validate $? "loading contents to mongodb"
