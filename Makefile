CURRENT_DIRECTORY := $(shell pwd)

TESTSCOPE = apps
TESTFLAGS = --with-timer --timer-top-n 10 --keepdb

help:
	@echo "Docker Compose Help"
	@echo "-----------------------"
	@echo ""
	@echo "Run tests to ensure current state is good:"
	@echo "    make test"
	@echo ""
	@echo "If tests pass, add fixture data and start up the api:"
	@echo "    make begin"
	@echo ""
	@echo "Really, really start over:"
	@echo "    make clean"
	@echo ""
	@echo "See contents of Makefile for more targets."

begin: start migrate

start:
	@docker-compose up -d admin traefik01

stop:
	@docker-compose stop

status:
	@docker-compose ps

restart: stop start

clean: stop
	@docker-compose rm --force
	@docker-compose down -v --remove-orphans

migrate:
	@sudo sysctl -w vm.max_map_count=262144
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop database bonde"
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop database fnserver"
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop database redash"
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop database metabase"
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop database concourse"
	@docker-compose exec -T pgmaster gosu postgres psql -c "drop role microservices"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database concourse"
	docker-compose restart migrations


extras: log monitor serverless

data:
	@docker-compose up -d metabase redash

log:
	@docker-compose up -d logspout kibana

monitor:
	@docker-compose up -d scope

serverless:
	@docker-compose up -d fnserver-ui

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean serverless log monitor tail
