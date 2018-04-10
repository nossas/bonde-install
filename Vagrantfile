# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'vagrant_rancheros_guest_plugin.rb'
# require 'vagrant-hostmanager'

# To enable rsync folder share change to false
$rsync_folder_disabled = false
$number_of_nodes = 1
$vm_mem = "3072"
# To use half cpus available
$vm_cpu = `awk "/^processor/ {++n} END {print n}" /proc/cpuinfo 2> /dev/null || sh -c 'sysctl hw.logicalcpu 2> /dev/null || echo ": 2"' | awk \'{print \$2}\' `.chomp
$vb_gui = false
$script = <<-SCRIPT
echo 'export PATH=$PATH:/opt/bonde/bin' >> .bashrc && source .bashrc

echo 'docker run --rm radial/busyboxplus:curl curl $@' > /opt/bonde/bin/curl && chmod +x /opt/bonde/bin/curl

curl -L https://github.com/docker/compose/releases/download/1.21.0-rc1/docker-compose-`uname -s`-`uname -m` >> /opt/bonde/bin/docker-compose && chmod +x /opt/bonde/bin/docker-compose

curl -L https://github.com/concourse/concourse/releases/download/v3.10.0/fly_linux_amd64 >> /opt/bonde/bin/fly && chmod +x /opt/bonde/bin/fly

curl -L https://github.com/drone/drone-cli/releases/download/v0.8.3/drone_linux_amd64.tar.gz | tar -xvzf
curl -L https://github.com/rancher/cli/releases/download/v1.0.0-alpha12/rancher-linux-amd64-v1.0.0-alpha12.tar.gz | tar -xvzf

sudo install -t /opt/bonde/bin drone
sudo install -t /opt/bonde/bin rancher

cd /opt/bonde
docker-compose down --remove-orphans
docker-compose up -d pgpool pgmaster
sleep 10;
docker-compose exec -T pgmaster gosu postgres psql -c "drop database fnserver"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database redash"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database metabase"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database concourse"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database bonde"
docker-compose exec -T pgmaster gosu postgres psql -c "drop role microservices"
docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
docker-compose exec -T pgmaster gosu postgres psql -c "create database concourse"
docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
docker-compose up -d migrations
sleep 5;
docker-compose up -d seeds
docker-compose up -d admin
docker-compose exec -T admin npm run build
sudo sysctl -w vm.max_map_count=262144
docker-compose restart traefik01
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box   = "furikuri/RancherOS"
  config.vm.box_version = ">=1.2.0"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  (1..$number_of_nodes).each do |i|
    hostname = "bonde.devel"
    config.vm.guest = :linux

    config.vm.define hostname do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.memory = $vm_mem
            vb.gui = $vb_gui
            vb.customize ["modifyvm", :id, "--cpus", $vm_cpu ]
            # vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
        end
        node.vm.provision "shell", inline: $script
        ip = "172.19.8.#{i+100}"
        node.vm.network "private_network", ip: ip
        node.vm.hostname = hostname

        node.hostmanager.aliases = %w( concourse.bonde.devel consul.bonde.devel smtp.bonde.devel traefik.bonde.devel s3.bonde.devel grafana.bonde.devel prometheus.bonde.devel api-v1.bonde.devel api-v2.bonde.devel kibana.bonde.devel fn-ui.bonde.devel app.bonde.devel weave.bonde.devel metabase.bonde.devel redash.bonde.devel )

        # Disabling compression because OS X has an ancient version of rsync installed.
        # Add -z or remove rsync__args below if you have a newer version of rsync on your machine.
        node.vm.synced_folder ".", "/opt/bonde", type: "rsync",
            rsync__exclude: [".git/", "node_modules/", "packages/", "tools/"], rsync__args: ["--verbose", "--archive", "--delete", "--copy-links"],
            disabled: $rsync_folder_disabled

    end
  end
end
