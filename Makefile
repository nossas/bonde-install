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

begin: migrate start

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
	@docker-compose exec  -T pgmaster gosu postgres psql -c "CREATE DATABASE fnserver;"

extras: log monitor serverless

log:
	@docker-compose up -d logspout kibana

monitor:
	@docker-compose up -d scope

serverless:
	@docker-compose up -d fnserver-ui

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean serverless log monitor tail
