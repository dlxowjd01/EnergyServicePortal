#!/bin/bash
BUILD_PATH=/usr/local/apache-tomcat-9.0.34/webapps/

echo "> 현재 실행중인 tomcat 애플리케이션 pid 확인"
CURRENT_PID=$(pgrep -f tomcat)

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 tomcat 애플리케이션이 없으므로 종료하지 않습니다."
else
  sudo -i $CATALINA_HOME/bin/shutdown.sh
  sleep 5
fi

WAR_NAME=energySerivcePortal-1.0.0.war
echo "> build 파일명: $WAR_NAME"

DEPLOY_PATH=/usr/local/apache-tomcat-9.0.34/webapps/
cd $DEPLOY_PATH

#jar -xvf $WAR_NAME

echo "> Web + API 배포"
sudo -i $CATALINA_HOME/bin/startup.sh
