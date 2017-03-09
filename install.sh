# Define colors
nc='\033[0m' # No Color
green='\033[0;32m'
gray='\033[1;30m'
blue='\033[0;34m'


echo "${green}# [1/9] Creating root directory...${nc}"
mkdir ~/code && cd ~/code && echo "${gray}Folder [$(pwd)] was created.${nc}"


echo "${green}# [2/9] Cloning repositories...${nc}"
git clone git@github.com:nossas/bonde-client.git
git clone git@github.com:nossas/bonde-server.git


echo "${green}# [3/9] Fetching branches...${nc}"
cd ~/code/bonde-server && git fetch origin
cd ~/code/bonde-client && git fetch origin && \
  git checkout -b develop origin/develop


echo "${green}# [4/9] Creating .env files...${nc}"
cd ~/code/bonde-server && cp '.env.example' '.env' && vi '.env' && \
  echo "${gray}File [$(pwd)/.env] was created.${nc}"

cd ~/code/bonde-client && cp '.env.example' '.env' && vi '.env' && \
  echo "${gray}File [$(pwd)/.env] was created.${nc}"


echo "${green}# [5/9] Running docker-compose...${nc}"
docker-compose up -d --build


echo "${green}# [6/9] Creating databases...${nc}"
docker-compose exec postgres psql -Upostgres -c 'create database reboo;' && \
  echo "${gray}Database [reboo] was created.${nc}"

docker-compose exec postgres psql -Upostgres -c 'create database reboo_test;' && \
  echo "${gray}Database [reboo_test] was created.${nc}"

docker-compose up -d --build


echo "${green}# [7/9] Running migrations...${nc}"
docker-compose exec api ./bin/rake db:migrate


echo "${green}# [8/9] Force rebuild...${nc}"
docker-compose up -d --build
docker-compose ps


echo "${green}# [9/9] Setting hosts up...${nc}"
env_app_domain=$(cat '.env' | grep APP_DOMAIN | awk -F '=' '{print $2}')
app_domain=$(echo $env_app_domain | awk -F ':' '{print $1}')
has_app_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$app_domain$")
if ! [ $has_app_domain ]; then
  sudo -- sh -c -e "echo '127.0.0.1\t$app_domain' >> /etc/hosts"
  echo "${gray}Host [$app_domain] successfully added.${nc}"
else
  echo "${gray}Host [$app_domain] already exists.${nc}"
fi

env_api_domain=$(cat '.env' | grep API_URL | awk -F '=' '{print $2}')
api_domain=$(echo "${env_api_domain/http:\/\//}" | awk -F ':' '{print $1}')
has_api_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$api_domain$")
if ! [ $has_api_domain ]; then
  sudo -- sh -c -e "echo '127.0.0.1\t$api_domain' >> /etc/hosts"
  echo "${gray}Host [$api_domain] successfully added.${nc}"
else
  echo "${gray}Host [$api_domain] already exists.${nc}"
fi


echo "\nEnjoy, it's all ready to start develop (;"
echo "-- Use ${blue}http://$env_app_domain${nc} to access the APP"
echo "-- Use ${blue}$env_api_domain${nc} to access the API"
