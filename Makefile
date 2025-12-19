-include .env
#———————————————————————————————————————#
# VARS                             		#
#———————————————————————————————————————#
APP_ENV?=local
ENV_ARG=--env-file ./.env

COMPOSE_BIN=@docker compose
COMPOSE_ARG=-f ./docker-compose.yaml

# COMPOSE CMD
COMPOSE_CMD=${COMPOSE_BIN} ${COMPOSE_ARG} ${ENV_ARG}

# PHONY
.PHONY: up down start stop build clean env host

#———————————————————————————————————————#
# CORE	                              	#
#———————————————————————————————————————#

init:
	$(MAKE) add-env
	@if [ "$(APP_ENV)" = "local" ]; then $(MAKE) add-host; fi
	$(MAKE) up

finish:
	$(MAKE) down
	@if [ "$(APP_ENV)" = "local" ]; then $(MAKE) rm-host; fi
	$(MAKE) rm-env

#———————————————————————————————————————#
# ACTIONS                             	#
#———————————————————————————————————————#

add-env:
	cp ./docker/env/.env.${APP_ENV} ./.env

rm-env:
	rm ./.env

add-host:
	echo "127.0.0.1 ${APP_DOMAIN}" | sudo tee -a /etc/hosts

rm-host:
	sudo sed -i '' '/${APP_DOMAIN}/d' /etc/hosts

up:
	$(COMPOSE_CMD) up -d --build --renew-anon-volumes

down:
	$(COMPOSE_CMD) down

start:
	${COMPOSE_CMD} start

stop:
	${COMPOSE_CMD} stop

clean:
	${COMPOSE_CMD} down
	docker system prune --all