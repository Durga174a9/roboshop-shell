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

dnf module disable mysql -y &>>log_file_path

validate $? " Disabling defaulf mysql-v"

cp /home/centos/robosgop-shell/service.mysql /etc/yum.repos.d/mysql.repo &>>log_file_path

validate $? " Copying sql location to mysql.repo"

dnf install mysql-community-server -y &>>log_file_path

validate $? "insatlling mysql"

systemctl enable mysqld &>>log_file_path

validate $? "Enabling mysqld"

systemctl start mysqld &>>log_file_path

validate $? "Starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>log_file_path

validate $? " changing defaulf password "

mysql -uroot -pRoboShop@1 &>>log_file_path

validate $? "Checking password'



