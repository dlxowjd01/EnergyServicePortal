#!/usr/bin/env bash
set -e

sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

echo "create volumes"
mkdir -p app/sonarqube/conf
mkdir -p app/sonarqube/data
mkdir -p app/sonarqube/logs
mkdir -p app/sonarqube/extensions
mkdir -p app/sonarqube/extensions/plugins
mkdir -p app/sonarqube/postgres
cp sonar-l10n-ko-plugin-1.7.0.jar app/sonarqube/extensions/plugins/.
chmod 777 app/sonarqube -R

echo "docker-compose up -d"
docker-compose up -d
