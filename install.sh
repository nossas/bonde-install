# Define colors
nc='\033[0m' # No Color
green='\033[0;32m'

echo "${green}# [STEP 01] Creating root directory...${nc}"
mkdir ~/code && cd ~/code
echo "$(pwd) created!"

echo "${green}# [STEP 02] Cloning the repos...${nc}"
git clone git@github.com:nossas/bonde-client.git
git clone git@github.com:nossas/bonde-server.git

echo "${green}# [STEP 03] Fetching branches...${nc}"
cd ~/code/bonde-server && git fetch origin
cd ~/code/bonde-client && git fetch origin && \
  git checkout -b develop origin/develop

echo "${green}# [STEP 04] Creating .env files...${nc}"
cd ~/code/bonde-server && cp '.env.example' '.env' && vi '.env' && echo "$(pwd)/.env created!"
cd ~/code/bonde-client && cp '.env.example' '.env' && vi '.env' && echo "$(pwd)/.env created!"

# # Make it run!
# docker-compose up -d

# # Create databases and run migrations
# docker-compose exec postgres psql -Upostgres -c 'create database reboo;'
# docker-compose exec postgres psql -Upostgres -c 'create database reboo_test;'
# docker-compose exec api ./bin/rake db:migrate

# # Force rebuild
# docker-compose up -d --build

# # Clear the directory stack
# dirs -c
