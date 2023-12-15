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

dnf install maven -y &>>log_file_path

validate $? " Installing maven "

id roboshop &>>log_file_path

if [ $? -ne 0 ]
then
    useradd roboshop
    validate $? "adding user roboshop"
else
    echo " user already exists" &>>log_file_path
fi

mkdir -p /app

validate $? "creating /app dir"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>log_file_path

validate $? "downloading shipping code"

cd /app

validate $? " Changing into /app directory"

unzip -o /tmp/shipping.zip &>>log_file_path

validate $? " unzipping code into /tmp/shipping.zip directory"

mvn clean package &>>log_file_path

validate $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar &>>log_file_path

cp /home/centos/roboshop-shell/service.shipping /etc/systemd/system/shipping.service &>>log_file_path

validate $? " copying shipping.service file"

systemctl daemon-reload &>>log_file_path

validate $? " Realoding deamon"

systemctl enable shipping &>>log_file_path

validate $? " Enabling shipping"

systemctl start shipping &>>log_file_path

validate $? " Starting shipping"

dnf install mysql -y &>>log_file_path

validate $? " installing sql "

mysql -h mysql.174a9.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>log_file_path

validate $? "loading contents into mysql"

systemctl restart shipping &>>log_file_path

validate $? "restarting shipping service"
