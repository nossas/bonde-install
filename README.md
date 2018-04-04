<img
  src="https://avatars2.githubusercontent.com/u/1479357?v=3&s=250"
  alt="Nossas logo"
  title="Nossas"
  align="right"
  height="75"
  width="75"
/>

# Bonde Install
This repository provides scripts to ease the docker development enviroment installation steps of Bonde App.

### Requirements

* VirtualBox ( 5.2.8 r121009 (Qt5.6.3) ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( 2.0.3 ) - https://www.vagrantup.com/downloads.html
* Make (optional) - https://www.gnu.org/software/make/
* Docker Compose ( optional - docker-compose version 1.20.1 ) - https://docs.docker.com/compose/install/

```
sudo vagrant plugin install vagrant-hostmanager
vagrant up
vagrant ssh
```

Ou:

```
docker-compose up -d
```

Ou

```
make install
```

# Install
```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/install.sh)
```

# Uninstall

```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/uninstall.sh)
```
