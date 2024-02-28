#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/home/centos/logsdir                    
#---------------->> change log file location 
# /home/centos/logsdir/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log

USERID=$(id -u)

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE() {
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp mongo.repo  /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

VALIDATE $? "copied mongo.repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enablong Mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MOngodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>> $LOGFILE

VALIDATE $? "Replacing IP"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MOngodb"
