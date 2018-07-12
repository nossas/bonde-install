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
	@docker-compose up -d pgmaster pgpool
	@sleep 5;
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database bonde"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database fnserver"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database redash"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database metabase"
	@docker-compose exec -T pgmaster gosu postgres psql -c "create database concourse"

migrate:
	@docker-compose -f docker-compose.workers.yml pull migrations
	@docker-compose -f docker-compose.workers.yml up -d migrations templates-email
	@sleep 20;

seeds:
	@docker-compose -f docker-compose.workers.yml up -d seeds

start:
	@docker-compose -f docker-compose.workers.yml up -d
	@docker-compose up -d storeconfig admin public
	@docker-compose restart traefik

stop:
	@docker-compose stop
	@docker-compose -f docker-compose.workers.yml stop
	@docker-compose -f docker-compose.dispatchers.yml stop
	@docker-compose rm --force
	@docker-compose -f docker-compose.workers.yml rm --force
	@docker-compose -f docker-compose.dispatchers.yml rm --force

status:
	@docker-compose ps
	@docker-compose -f docker-compose.workers.yml ps
	@docker-compose -f docker-compose.dispatchers.yml ps

restart: stop start rebuild

clean:
	@docker-compose down -v --remove-orphans
	@docker-compose -f docker-compose.workers.yml down -v --remove-orphans
	@docker-compose -f docker-compose.dispatchers.yml down -v --remove-orphans

rebuild:
	@docker-compose exec -T admin npm run buildx
	@docker-compose exec -T public npm run build

extras:
	@docker-compose up -d s3 smtp

dispatchers:
	@docker-compose -f docker-compose.dispatchers.yml up -d
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps delete domain
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps create domain
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain DATABASE_URL postgres://monkey_user:monkey_pass@pgpool:5432/bonde
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain AWS_REGION aws_region
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain AWS_ACCESS_KEY_ID aws_access_key_id
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain AWS_SECRET_ACCESS_KEY aws_secret_access_key
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain AWS_ROUTE_IP aws_route_ip
	@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn apps config s domain JWT_SECRET jwt_secret_key
	# @@FN_REGISTRY=nossas FN_API_URL=fn.bonde.devel fn deploy --app domain

logs:
	@docker-compose -f docker-compose.workers.yml -f docker-compose.dispatchers.yml -f docker-compose.yml logs -f

start-logger:
	@docker-compose -f docker-compose.monitor.yml up -d logspout kibana

start-monitor:
	@docker-compose -f docker-compose.monitor.yml up -d scope

tail:
	@docker-compose logs -f

.PHONY: start stop status restart clean setup migrate seeds dispatchers serverless logs start-logger start-monitor tail
