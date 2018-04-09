# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'vagrant_rancheros_guest_plugin.rb'
# require 'vagrant-hostmanager'

# To enable rsync folder share change to false
$rsync_folder_disabled = false
$number_of_nodes = 1
$vm_mem = "3072"
# $vm_cpu = 2
$vb_gui = false
$script = <<-SCRIPT
COMPOSER_FILE="docker-compose-`uname -s`-`uname -m`"
wget https://github.com/docker/compose/releases/download/1.21.0-rc1/${COMPOSER_FILE}
sudo mv ${COMPOSER_FILE} /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

cd /opt/bonde
docker-compose down --remove-orphans
docker-compose up -d pgpool pgmaster
docker-compose exec -T pgmaster gosu postgres psql -c "drop database fnserver"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database redash"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database metabase"
docker-compose exec -T pgmaster gosu postgres psql -c "drop database bonde"
docker-compose exec -T pgmaster gosu postgres psql -c "drop role microservices"
docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
docker-compose up -d migrations
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
            vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
        end
        node.vm.provision "shell", inline: $script
        ip = "172.19.8.#{i+100}"
        node.vm.network "private_network", ip: ip
        node.vm.hostname = hostname

        node.hostmanager.aliases = %w( consul.bonde.devel smtp.bonde.devel traefik.bonde.devel s3.bonde.devel grafana.bonde.devel prometheus.bonde.devel api-v1.bonde.devel api-v2.bonde.devel kibana.bonde.devel fn-ui.bonde.devel app.bonde.devel weave.bonde.devel metabase.bonde.devel redash.bonde.devel )

        # Disabling compression because OS X has an ancient version of rsync installed.
        # Add -z or remove rsync__args below if you have a newer version of rsync on your machine.
        node.vm.synced_folder ".", "/opt/bonde", type: "rsync",
            rsync__exclude: [".git/", "node_modules/", "packages/", "tools/"], rsync__args: ["--verbose", "--archive", "--delete", "--copy-links"],
            disabled: $rsync_folder_disabled

    end
  end
end
