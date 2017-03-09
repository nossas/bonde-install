# Define colors
nc='\033[0m' # No Color
green='\033[0;32m'
gray='\033[1;30m'


echo "${green}# [1/9] Creating root directory...${nc}"
mkdir ~/code && cd ~/code
echo "${gray}$(pwd) created.${nc}"


echo "${green}# [2/9] Cloning repositories...${nc}"
git clone git@github.com:nossas/bonde-client.git
git clone git@github.com:nossas/bonde-server.git


echo "${green}# [3/9] Fetching branches...${nc}"
cd ~/code/bonde-server && git fetch origin
cd ~/code/bonde-client && git fetch origin && \
  git checkout -b develop origin/develop


echo "${green}# [4/9] Creating .env files...${nc}"
cd ~/code/bonde-server && cp '.env.example' '.env' && vi '.env'
echo "${gray}$(pwd)/.env created.${nc}"
cd ~/code/bonde-client && cp '.env.example' '.env' && vi '.env'
echo "${gray}$(pwd)/.env created.${nc}"


echo "${green}# [5/9] Running docker-compose...${nc}"
docker-compose up -d --build


echo "${green}# [6/9] Creating databases...${nc}"
docker-compose exec postgres psql -Upostgres -c 'create database reboo;'
echo "${gray}database [reboo] was created successfully.${nc}"
docker-compose exec postgres psql -Upostgres -c 'create database reboo_test;'
echo "${gray}database [reboo_test] was created successfully.${nc}"
docker-compose up -d --build


echo "${green}# [7/9] Running migrations...${nc}"
docker-compose exec api ./bin/rake db:migrate


echo "${green}# [7/9] Force rebuild...${nc}"
docker-compose up -d --build
docker-compose ps


echo "${green}# [8/9] Setting hosts up...${nc}"
app_domain=$(cat '.env' | grep APP_DOMAIN | awk -F '=' '{print $2}' | awk -F ':' '{print $1}')
has_app_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$app_domain$")
if ! [ $has_app_domain ]; then sudo -- sh -c -e "echo '127.0.0.1\t$app_domain' >> /etc/hosts"; fi
echo "${gray}host [$app_domain] successfully added.${nc}"

api_domain=$(cat '.env' | grep API_URL | { read x; echo "${x/API_URL=http:\/\//}"; } | awk -F ':' '{print $1}')
has_api_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$api_domain$")
if ! [ $has_api_domain ]; then sudo -- sh -c -e "echo '127.0.0.1\t$api_domain' >> /etc/hosts"; fi
echo "${gray}host [$api_domain] successfully added.${nc}"


echo "\nEnjoy, it's all ready to start develop (;"
