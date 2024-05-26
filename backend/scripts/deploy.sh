#!/bin/bash

ROOT_PATH="/home/ubuntu/dodo"
JAR="$ROOT_PATH/application.jar"

APP_LOG="$ROOT_PATH/application.log"
ERROR_LOG="$ROOT_PATH/error.log"
START_LOG="$ROOT_PATH/start.log"
STOP_LOG="$ROOT_PATH/stop.log"

SERVICE_PID=$(pgrep -f $JAR)

if [ -z "$SERVICE_PID" ]; then
  echo "서비스 NouFound" >> $STOP_LOG
else
  echo "서비스 중지 " >> $STOP_LOG
  kill -9 "$SERVICE_PID"
fi

NOW=$(date +%c) 

echo "[$NOW] $JAR 복사" >> $START_LOG
cp $ROOT_PATH/build/libs/dodo-0.0.1-SNAPSHOT.jar $JAR

echo "[$NOW] > $JAR 실행" >> $START_LOG
nohup java -jar $JAR > $APP_LOG 2> $ERROR_LOG &

SERVICE_PID=$(pgrep -f $JAR)
echo "[$NOW] > 서비스 PID: $SERVICE_PID" >> $START_LOG