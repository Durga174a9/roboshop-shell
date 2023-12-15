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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>log_file_path

validate $? "Installing redis repo's"

dnf module enable redis:remi-6.2 -y &>>log_file_path

validate $? "enabling redis version-6.2"

dnf install redis -y &>>log_file_path

validate $? "installing redis package"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>log_file_path

validate $? "changing ip to access all-request"

systemctl enable redis &>>log_file_path

validate $? " enabling redis service"

systemctl start redis &>>log_file_path

validate $? " Starting redis service"

