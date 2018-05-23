<img
  src="https://avatars2.githubusercontent.com/u/1479357?v=3&s=250"
  alt="Nossas logo"
  title="Nossas"
  align="right"
  height="75"
  width="75"
/>

# Bonde Install
This repository provides scripts to ease the development. To do that, configurations  are abstracted to containers with docker.

## Requirements

Our development setup could be started by two ways, using vagrant or with local docker.

If you only want to start containers locally:
* Docker ( required 17.10.0-ce or later ) - https://docs.docker.com/install/
* Docker Compose ( required: 1.20.1 ) - https://docs.docker.com/compose/install/
* Make ( optional: 3.81 ) - https://www.gnu.org/software/make/

To provision services using VirtualBox and Vagrant, we recomend the following versions:
* VirtualBox ( required: 5.2.8 r121009 ) - https://www.virtualbox.org/wiki/Downloads
* Vagrant ( required: 2.0.3 ) - https://www.vagrantup.com/downloads.html


## Install

In the first scenario, running the commands will result in downloading great amount of gigabytes and some commands hungry to cpu consumption:

```
make migrate
make start
```

Add to ```/etc/hosts``` following lines:

```
# Bonde Web Servers
127.0.0.1 bonde.devel
127.0.0.1 app.bonde.devel
127.0.0.1 admin-canary.bonde.devel
127.0.0.1 2-save-the-whales.bonde.devel
127.0.0.1 3-vamos-limpar-o-tiete.bonde.devel
127.0.0.1 1-vamos-limpar-o-tiete.bonde.devel
127.0.0.1 api-v1.bonde.devel
127.0.0.1 api-v2.bonde.devel

# Bonde Dispatchers
127.0.0.1 fn.bonde.devel
127.0.0.1 fn-ui.bonde.devel

# Bonde Commons
127.0.0.1 consul.bonde.devel
127.0.0.1 fake-smtp.bonde.devel
127.0.0.1 traefik.bonde.devel
127.0.0.1 fake-s3.bonde.devel

# Bonde Log and Monitor
127.0.0.1 grafana.bonde.devel
127.0.0.1 prometheus.bonde.devel
127.0.0.1 kibana.bonde.devel
127.0.0.1 weave.bonde.devel
```

Now you should be able to access third-party tools used by our modules:

* fake-s3.bonde.devel
* fake-smtp.bonde.devel
* consul.bonde.devel
* traefik.bonde.devel

And these are essentials URLs from BONDE and must be accessible to get local copy fully working:

* api-v1.bonde.devel
* api-v2.bonde.devel
* app.bonde.devel
* admin-canary.bonde.devel
* 1-vamos-limpar-o-tiete.bonde.devel
* 2-save-the-whales.bonde.devel
* 3-vamos-limpar-o-tiete.bonde.devel


Or to the second:

```
sudo vagrant plugin install vagrant-hostmanager
vagrant up
```

We have some  services used in production to monitor, log and analyze containers. To enable, just type:

```
make start-logger
make monitor

```

## Architecture

We break architecture into three categories: Essentials, Specifics and Extras. Each category, has some modules and they have a brief introduction.

Each module must be correspond to one repository.

### Essentials:
* **nossas/bonde-client** - web servers to the following interfaces: public, admin, and admin-canary;
* **nossas/bonde-server** - api-v1 - web server e workers responsáveies por assinatura, pressão e doação, configuração do admin;
* **nossas/bonde-graphql** - api-v2 - web server responsável pela autenticação, registro de usuário, tags, mobilização, etc.
* **nossas/bonde-microservices** - funções serverless do fn project como: domain, notification e mailchimp, etc.
* **nossas/bonde-migrations** - scritps sql necessários para reconstruir a estrutura do banco de dados

### Specifics:
* **nossas/bonde-phone** - webserver and worker created to integrate with twillio
* **nossas/bonde-bot** - webserver and worker created to integrate with facebook messenger
* **nossas/bonde-payments** - worker para sincronização das transações do pagarme

### Extras:
* **nossas/bonde-maquinista** - chatbot criado utilizando o hubot com intuito de facilitar gerenciamento do BONDE
* **nossas/bonde-docs** - espaço para publicação de conteúdo didático e técnico sobre o BONDE
* **nossas/bonde-test** - teste de integração utilizando google chrome headless
* **nossas/bonde-install** - configurações para funcionamento no ambiente de desenvolvimento
* **nossas/slate-editor** - biblioteca criada para suprir nossa demanda de um editor


# Easy Install
```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/install.sh)
```

# Uninstall

```sh
sh <(curl -s https://raw.githubusercontent.com/nossas/bonde-install/master/uninstall.sh)
```

Additional Resources:

* Rancher CLI - https://rancher.com/docs/rancher/latest/en/cli/
* Drone CLI - http://docs.drone.io/cli-installation/
* Fn CLI - https://github.com/fnproject/cli/releases/
