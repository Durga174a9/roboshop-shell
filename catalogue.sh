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

validate $? "Disabling defalult version of nodejs"

dnf module enable nodejs:18 -y &>>log_file_path

validate $? "enabling defalult version of nodejs"

which nodejs &>>log_file_path

if [ $? -ne 0 ]
then
    dnf install nodejs -y &>>log_file_path
    validate $? "installing nodejs"
else
    echo "nodejs already installed"
fi

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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>log_file_path

validate $? "Downloading catalogue application"

cd /app

unzip -o /tmp/catalogue.zip &>>log_file_path

npm install &>>log_file_path

validate $? "insatlling dependencies"

cp home/centos/roboshop-shell/service.catalouge /etc/systemd/system/catalogue.service

validate $? "copying service file"

systemctl daemon-reload &>>log_file_path

validate $? "reloading deamon"

systemctl enable catalogue &>>log_file_path

validate $? "Enabling cataloge service"

systemctl start catalogue &>>log_file_path

validate $? "starting catalogue"

cp  home/centos/roboshop-shell/mongorepo /etc/yum.repos.d/mongo.repo 

validate $? "copying mongorepo to etc/yum.repos.d/mongo.repo"

dnf install mongodb-org-shell -y &>>log_file_path

validate $? " insatlling mongo-shell "

mongo --host 54.152.150.133 </app/schema/catalogue.js &>>log_file_path

validate $? "Loading catalouge data into mongodb"







