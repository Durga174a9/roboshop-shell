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

dnf install python36 gcc python3-devel -y &>>log_file_path

validate $? " Installing python -v 3.6"

id roboshop &>>log_file_path

if [ $? -ne 0 ]
then
    useradd roboshop &>>log_file_path
    validate $? "adding user roboshop"
else
    echo "user already exist"
fi

mkdir -p /app 

validate $? "creating /app dir"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>log_file_path

validate $? "Downloading code .."

cd /app 

pip3.6 install -r requirements.txt &>>log_file_path

validate $? " installing dependencies"

cp /home/centos/roboshop-shell/service.payment /etc/systemd/system/payment.service &>>log_file_path

validate $? "copying service.payment to payment.service"

systemctl daemon-reload &>>log_file_path

validate $? " Re-loading deamon"


systemctl enable payment &>>log_file_path

validate $? " Enabling payment"


systemctl start payment &>>log_file_path

validate $? " starting payment



