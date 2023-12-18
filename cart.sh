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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>log_file_path

validate $? "Downloading cart code"

cd /app

unzip -o /tmp/cart.zip &>>log_file_path

validate $? "Unzipping code in /tmp/cart.zip directory"

npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/service.cart /etc/systemd/system/cart.service &>>log_file_path

validate $? "copying service.cart to cart.service"

systemctl daemon-reload &>>log_file_path

validate $? "Re-loading deamon" 

systemctl enable cart &>>log_file_path

validate $? "Enabling cart service" 

systemctl start cart &>>log_file_path

validate $? "starting cart service"




