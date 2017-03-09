# Define colors
nc='\033[0m' # No Color
green='\033[0;32m'
gray='\033[1;30m'

# Store current location
initial_location=$(pwd)

echo "${green}# [1/5] Shutting down containers...${nc}"
cd ~/code/bonde-client
docker stop `docker ps -a | grep bondeclient | awk '{print $1}'`


echo "${green}# [2/5] Removing containers...${nc}"
docker rm `docker ps -a | grep bondeclient | awk '{print $1}'`


echo "${green}# [3/5] Removing images...${nc}"
docker rmi $(docker images -a | grep 'bondeclient' | awk '{print $1}')
docker rmi $(docker images -a | grep '<none>' | awk '{print $3}')


echo "${green}# [4/5] Removing volumes...${nc}"
docker volume rm $(docker volume ls -f dangling=true -q)


echo "${green}# [5/5] Removing directories...${nc}"
cd $initial_location
rm -rf ~/code/bonde-client && echo "${gray}Directory [~/code/bonde-client] was removed.${nc}"
rm -rf ~/code/bonde-server && echo "${gray}Directory [~/code/bonde-server] was removed.${nc}"
! [ "$(ls -A ~/code)" ] && rm -rf ~/code && echo "${gray}Directory [~/code] was removed.${nc}"

echo '\nSuccessfully uninstalled.'
