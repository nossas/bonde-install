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

begin: pull setup migrate seeds start-dev

setup:
	@docker-compose up -d pgmaster

migrate:
	@printf "Waiting for pgmaster..."
	@until \
		(docker-compose exec -T pgmaster psql -Umonkey_user -lqt | cut -d \| -f 1 | grep -qw monkey_db) > /dev/null 2>&1; \
		do sleep 1; printf ".";\
	done && printf "\n";
	@docker-compose exec -T pgmaster psql -Umonkey_user monkey_db -c "create database bonde;"
	# @docker-compose exec -T pgmaster psql -Umonkey_user monkey_db -c "create role postgraphql login password '3x4mpl3'; create role reboo; create role anonymous; create role common_user; create role admin; create role postgres; create role microservices;"
	# @docker-compose build migrations
	# @docker-compose up -d migrations

seeds:
	@sleep 10;
	#@docker-compose -f docker-compose.workers.yml up -d templates-email

start-dev:
	@docker-compose up -d
	@docker-compose -f docker-compose.apis.yml up -d
	@docker-compose -f docker-compose.clients.yml up -d

# start:
# 	@docker-compose up -d
# 	@docker-compose -f docker-compose.apis.yml up -d
# 	@docker-compose -f docker-compose.clients.yml up -d
# 	@docker-compose -f docker-compose.common.yml up -d
# 	@docker-compose -f docker-compose.cronjob.yml up -d
# 	@docker-compose -f docker-compose.listeners.yml up -d
# 	@docker-compose -f docker-compose.webhooks.yml up -d
# 	@docker-compose -f docker-compose.workers.yml up -d

stop:
	@docker-compose stop
	@docker-compose rm --force
	@docker-compose -f docker-compose.apis.yml stop
	@docker-compose -f docker-compose.apis.yml rm --force
	@docker-compose -f docker-compose.clients.yml stop
	@docker-compose -f docker-compose.clients.yml rm --force
	@docker-compose -f docker-compose.common.yml stop
	@docker-compose -f docker-compose.common.yml rm --force
	@docker-compose -f docker-compose.cronjob.yml stop
	@docker-compose -f docker-compose.cronjob.yml rm --force
	@docker-compose -f docker-compose.listeners.yml stop
	@docker-compose -f docker-compose.listeners.yml rm --force
	@docker-compose -f docker-compose.webhooks.yml stop
	@docker-compose -f docker-compose.webhooks.yml rm --force
	@docker-compose -f docker-compose.workers.yml stop
	@docker-compose -f docker-compose.workers.yml rm --force

status:
	@docker-compose ps
	@docker-compose -f docker-compose.apis.yml ps
	@docker-compose -f docker-compose.clients.yml ps
	@docker-compose -f docker-compose.common.yml ps
	@docker-compose -f docker-compose.cronjob.yml ps
	@docker-compose -f docker-compose.listeners.yml ps
	@docker-compose -f docker-compose.webhooks.yml ps
	@docker-compose -f docker-compose.workers.yml ps

clean:
	@docker-compose down -v --remove-orphans
	@docker-compose -f docker-compose.apis.yml down -v --remove-orphans
	@docker-compose -f docker-compose.clients.yml down -v --remove-orphans
	@docker-compose -f docker-compose.common.yml down -v --remove-orphans
	@docker-compose -f docker-compose.cronjob.yml down -v --remove-orphans
	@docker-compose -f docker-compose.listeners.yml down -v --remove-orphans
	@docker-compose -f docker-compose.webhooks.yml down -v --remove-orphans
	@docker-compose -f docker-compose.workers.yml down -v --remove-orphans

logs:
	@docker-compose logs -f
	@docker-compose -f docker-compose.apis.yml logs -f
	@docker-compose -f docker-compose.clients.yml logs -f
	@docker-compose -f docker-compose.common.yml logs -f
	@docker-compose -f docker-compose.cronjob.yml logs -f
	@docker-compose -f docker-compose.listeners.yml logs -f
	@docker-compose -f docker-compose.webhooks.yml logs -f
	@docker-compose -f docker-compose.workers.yml logs -f

restart: stop start

clients-rebuild:
	@docker-compose -f docker-compose.clients.yml exec -T clients pnpm m run build --filter {libs}
	@docker-compose -f docker-compose.clients.yml exec -T clients pnpm m run build --filter {packages}

extras:
	@docker-compose -f docker-compose.common.yml up -d

pull:
	@docker-compose pull

.PHONY: start stop status restart clean setup migrate seeds serverless logs start-logger start-monitor tail
