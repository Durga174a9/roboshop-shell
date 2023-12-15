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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>log_file_path

validate $? "Config  yum repo's for vendor"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>log_file_path

validate $? " Configure YUM Repos for RabbitMQ"

dnf install rabbitmq-server -y &>>log_file_path

validate $? " installing rabbitmq"

systemctl enable rabbitmq-server &>>log_file_path

validate $? " Enabling RabbitMQ"

systemctl start rabbitmq-server &>>log_file_path

validate $? " Starting RabbitMQ"

rabbitmqctl add_user roboshop roboshop123 &>>log_file_path

validate $? " Adding user and password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>log_file_path

validate $? " Providing permission to user "

