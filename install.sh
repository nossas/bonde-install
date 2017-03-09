# Create root directory
mkdir ~/code && cd ~/code

# Clone the repos
git clone git@github.com:nossas/bonde-client.git
git clone git@github.com:nossas/bonde-server.git

# Fetch branches and checkout into it
cd ~/code/bonde-server && git fetch origin
cd ~/code/bonde-client && git fetch origin && \
  git checkout -b develop origin/develop

# Create .env files
cd ~/code/bonde-server && cp '.env.example' '.env' && vi '.env'
cd ~/code/bonde-client && cp '.env.example' '.env' && vi '.env'