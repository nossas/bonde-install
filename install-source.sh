# Define colors
nc='\033[0m' # No Color
green='\033[0;32m'
gray='\033[1;30m'
blue='\033[0;34m'


# echo "${green}# [1/9] Creating root directory...${nc}"
mkdir ../bonde && cd ../bonde && echo "${gray}Folder [$(pwd)] was created.${nc}"


echo "${green}# [2/9] Cloning repositories...${nc}"
git clone git@github.com:nossas/bonde-install.git install
git clone git@github.com:nossas/bonde-server.git api-rest
git clone git@github.com:nossas/bonde-migrations.git migrations
git clone git@github.com:nossas/bonde-grpahql.git api-v2
git clone git@github.com:nossas/bonde-maquinista.git maquinista
git clone git@github.com:nossas/bonde-bot.git chatbot
git clone git@github.com:nossas/bonde-phone.git phone
git clone git@github.com:nossas/bonde-redirect.git redirect
git clone git@github.com:nossas/bonde-cache.git cache
# git clone git@gitlab.com:nossas/bonde-match.git match

echo "${green}# [3/9] Fetching branches...${nc}"
cd install && git fetch origin
# cd ~/code/bonde-client && git fetch origin && \
#   git checkout -b develop origin/develop

# echo "${green}# [4/9] Creating .env files...${nc}"
# cd ~/code/bonde-server && cp '.env.example' '.env' && vi '.env' && \
#   echo "${gray}File [$(pwd)/.env] was created.${nc}"

# cd ~/code/bonde-client && cp '.env.example' '.env' && vi '.env' && \
#   echo "${gray}File [$(pwd)/.env] was created.${nc}"

echo "${green}# [6/9] Creating databases and running docker-compose...${nc}"
make begin && \
  echo "${gray}Database [bonde] was created.${nc}"

# docker-compose up -d --build

# echo "${green}# [7/9] Running migrations...${nc}"
# docker-compose exec migrations

# echo "${green}# [8/9] Force rebuild...${nc}"
# docker-compose up -d --build
# docker-compose ps


# echo "${green}# [9/9] Setting hosts up...${nc}"
# env_app_domain=$(cat '.env' | grep APP_DOMAIN | awk -F '=' '{print $2}')
# app_domain=$(echo $env_app_domain | awk -F ':' '{print $1}')
# has_app_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$app_domain$")
# if ! [ $has_app_domain ]; then
#   sudo -- sh -c -e "echo '127.0.0.1\t$app_domain' >> /etc/hosts"
#   echo "${gray}Host [$app_domain] successfully added.${nc}"
# else
#   echo "${gray}Host [$app_domain] already exists.${nc}"
# fi

# env_api_domain=$(cat '.env' | grep API_URL | awk -F '=' '{print $2}')
# api_domain=$(echo "${env_api_domain/http:\/\//}" | awk -F ':' '{print $1}')
# has_api_domain=$(awk '{print $2}' /etc/hosts | grep -v '^$' | grep "^$api_domain$")
# if ! [ $has_api_domain ]; then
#   sudo -- sh -c -e "echo '127.0.0.1\t$api_domain' >> /etc/hosts"
#   echo "${gray}Host [$api_domain] successfully added.${nc}"
# else
#   echo "${gray}Host [$api_domain] already exists.${nc}"
# fi

echo "\nEnjoy, it's all ready to start develop (;"
echo "-- Use ${blue}http://$env_app_domain${nc} to access the APP"
echo "-- Use ${blue}$env_api_domain${nc} to access the API"
