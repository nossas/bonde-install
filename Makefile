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

begin: setup migrate seeds start-dev

setup:
	@docker-compose up -d pgmaster

migrate:
	@printf "Waiting for pgmaster..."
	@until \
		(docker-compose exec -T pgmaster psql -Umonkey_user -lqt | cut -d \| -f 1 | grep -qw monkey_db) > /dev/null 2>&1; \
		do sleep 1; printf ".";\
	done && printf "\n";
	@docker-compose exec -T pgmaster psql -Umonkey_user monkey_db -c "create database bonde"
	@docker-compose -f docker-compose.workers.yml pull migrations
	@docker-compose -f docker-compose.workers.yml up -d migrations templates-email

seeds:
	@sleep 10
	@docker-compose -f docker-compose.workers.yml up -d seeds
	@docker-compose run api-v3 python manage.py db upgrade
	@docker-compose exec -T pgmaster psql -Umonkey_user bonde -c "INSERT INTO \
    facebook_bot_configurations( \
        community_id, \
        messenger_app_secret, \
        messenger_validation_token, \
        messenger_page_access_token, \
        data, \
        created_at, \
        updated_at \
    ) VALUES ( \
        1, \
        'a42721a1f86867b2a42ac560a3b90ba9', \
        'amaioraliadafeministanasredes', \
        'EAARX5lZC7CosBALvAQJNN0FZCv6rkhv76f6xjePGUdSzWhn0EKb9HoOpTicomUbjnISUmeZADlGI5oWk0EqhGwCTocvPLl7IKEWVXqKWBwZC0kKexdrjqG29jJOiq5Fs2drSWFFd1RrX7AiQZAZB6U6vCbB5UfKHEhyYXUZAqHG7wZDZD', \
        '{\"m_me\": \"https://m.me/beta.staging\", \"name\": \"BETA\", \"pressure\": {\"slug\": \"educacao-faz-meu-genero\", \"widget_id\": 16758}, \"image_url\": \"https://s3.amazonaws.com/chatbox-beta/nascituro-rj-nao/share.jpg\"}', \
        now(), \
        now() \
    )"

start:
	@docker-compose -f docker-compose.workers.yml up -d
	@docker-compose up -d admin admin-canary public
	@docker-compose restart traefik

start-dev:
	@docker-compose up -d traefik
	@docker-compose -f docker-compose.workers.yml up -d
	@docker-compose up -d cross-storage api-v1 api-v2 api-v3 notifications
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
