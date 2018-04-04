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

Our development setup could be started by two ways, using vagrant or with local docker.

To provision services using VirtualBox and Vagrant, we recomend the following versions:
* VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html

If you want to start locally:
* Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
* Make ( optional: 3.81 ) - https://www.gnu.org/software/make/

# Install
In the first scenario:
```
sudo vagrant plugin install vagrant-hostmanager
vagrant up
```

Or to the second:

```
make start
```

We have some extra services used in production to monitor, log and analyze containers. To enable, just type:

```
make extras
```


# Easy Install
```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/install.sh)
```

# Uninstall

```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/uninstall.sh)
```
