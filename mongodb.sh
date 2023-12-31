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

cp ./mongorepo /etc/yum.repos.d/mongo.repo

validate $? "Copied file to /etc/yum.repos.d/mongo.repo"

dnf install mongodb-org -y &>>log_file_path

validate $? "installing mongodb "

systemctl enable mongod &>>log_file_path

validate $? "Enabling mongodb  "

systemctl start mongod &>>log_file_path

validate $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>log_file_path

validate $? "editing /etc/mongodb file"

systemctl restart mongod &>>log_file_path

validate $? " Restaring mongodb"
