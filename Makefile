CURRENT_DIRECTORY := $(shell pwd)

TESTSCOPE = apps
TESTFLAGS = --with-timer --timer-top-n 10 --keepdb

help:
	@echo "Docker Compose Help"
	@echo "-----------------------"
	@echo ""
	@echo "Run cleaner task to ensure current state is good:"
	@echo "    make clean"
	@echo ""
	@echo "Start common services: load balancer, consul and web bonde:"
	@echo "    make begin"
	@echo ""
	@echo "Start extra dependencies: smtp, s3, etc :"
	@echo "    make extras"
	@echo ""
	@echo "See contents of Makefile for more targets."

begin: setup migrate seeds start

setup:
	@docker-compose up -d pgmaster

migrate:
	@docker-compose -f docker-compose.workers.yml pull migrations
	@docker-compose -f docker-compose.workers.yml up -d migrations templates-email

seeds:
	@sleep 10;
	@docker-compose -f docker-compose.workers.yml up -d seeds

start:
	@docker-compose up -d storeconfig cross-storage api-v1 api-v2 notifications
	@docker-compose restart traefik

stop:
	@docker-compose stop
	@docker-compose -f docker-compose.workers.yml stop
	@docker-compose rm --force
	@docker-compose -f docker-compose.workers.yml rm --force

status:
	@docker-compose ps
	@docker-compose -f docker-compose.workers.yml ps

restart: stop start

clean:
	@docker-compose down -v --remove-orphans
	@docker-compose -f docker-compose.workers.yml down -v --remove-orphans

frontend-rebuild:
	@docker-compose exec -T public npm run build

extras:
	@docker-compose up -d s3 smtp

logs:
	@docker-compose -f docker-compose.workers.yml -f docker-compose.yml logs -f

start-logger:
	@docker-compose -f docker-compose.monitor.yml up -d logspout kibana

start-monitor:
	@docker-compose -f docker-compose.monitor.yml up -d scope

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean setup migrate seeds serverless logs start-logger start-monitor tail
