#!/bin/bash
BUILD_PATH=/home/ubuntu/build/

echo "> 현재 실행중인 tomcat 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f tomcat)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 tomcat 애플리케이션이 없으므로 종료하지 않습니다."
else
  sudo service tomcat stop
  sleep 5
fi

JAR_NAME=ewp-api-0.0.1-SNAPSHOT.jar
echo "> build 파일명: $JAR_NAME"

APPLICATION_JAR_NAME=ewp-api.jar
DEPLOY_PATH=/home/ubuntu/ewpsp_batch/lib/
APPLICATION_JAR=$DEPLOY_PATH$APPLICATION_JAR_NAME

echo "> $APPLICATION_JAR 배포"
cp -R $BUILD_PATH$JAR_NAME $APPLICATION_JAR

WAR_NAME=ewpsp.war
echo "> build 파일명: $WAR_NAME"

DEPLOY_PATH=/home/ubuntu/ewpsp
cd $DEPLOY_PATH

cp -R $BUILD_PATH$WAR_NAME .
jar -xvf $WAR_NAME

echo "> Web + API 배포"
sudo service tomcat start