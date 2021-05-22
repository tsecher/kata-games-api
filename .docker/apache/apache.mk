include .env

.PHONY: up down stop prune ps shell drush logs composer sh install update build

default: up

CONNECT_SERVER ?= docker exec -ti --user www-data $(COMPOSE_PROJECT_NAME)_server
CONNECT_SERVER_ROOT ?= docker exec -ti --user root $(COMPOSE_PROJECT_NAME)_server

help:  ## Affiche l'aide du Makefile
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'



##
#############################    Docker    #####################################

build-all: ## Build tous les containers nécessaires.
	#### Build de maria DB si il n'est pas déjà up.
	- make mariadb-up

	### Build de traefik si il n'est pas déjà up.
	- make traefik-up

	### Build de traefik si il n'est pas déjà up.
	- make stop

	#### Build apache
	make up

	#### Création de la db
	- make db-create

build: ## Build les containers
	@echo "Rebuild containers $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} build

up: ## Lance les containers
	@echo "Starting up containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} up -d

pull: ## Pull donw les containers ?
	@echo "Pull down containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} pull --parallel

stop: ## Arrête les containers
	@echo "Stopping containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop

halt: stop

prune: ## Supprime les containers
	@echo "Removing containers for $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} down -v --remove-orphans

rmi: ## Supprime les containers et images
	@echo "Removing containers for $(COMPOSE_PROJECT_NAME)..."
	@if [ "$(shell bash -c 'read -s -p "Vous allez supprimer les images, êtes-vous sûr? [y/n]: " pwd; echo $$pwd')" = "y" ]; then\
	    @docker-compose -f ${APACHE_COMPOSE_FILE} stop;\
	    make prune;\
		docker-compose -f ${APACHE_COMPOSE_FILE} down --rmi local -v;\
	fi

ps: ## Affiche les infos des containers liés au projet.
	@docker ps --filter name='$(COMPOSE_PROJECT_NAME)*'

build-no-cache: ## build sans cache.
	@echo "Rebuild containers $(COMPOSE_PROJECT_NAME)..."
	@docker-compose -f ${APACHE_COMPOSE_FILE} build --no-cache


##
#############################    Containers    #####################################
apache-connect: ## Connection auc ontainer apache.
	$(CONNECT_SERVER) bash $(filter-out $@,$(MAKECMDGOALS))

server-connect: ## Connection auc ontainer apache.
	make apache-connect

##
#############################    Composer    #####################################
composer: ## Commande composer.
	$(CONNECT_SERVER) php -d memory_limit=-1 "/usr/local/bin/composer" $(filter-out $@,$(MAKECMDGOALS))

db-create: ## Création de la base de données.
	$(CONNECT_SERVER_ROOT) mysql -h ${MYSQL_HOST} -u root -proot -e "CREATE DATABASE IF NOT EXISTS $(MYSQL_DATABASE); GRANT ALL PRIVILEGES ON $(MYSQL_DATABASE).* TO '$(MYSQL_USER)'@'%' WITH GRANT OPTION;"

##
#############################    Conf PHP    #####################################

disable-opcache: ## Désactiver opcache
	$(CONNECT_SERVER_ROOT) cp /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/save_opcache
	$(CONNECT_SERVER_ROOT) mv /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini /usr/local/etc/php/conf.d/dis_opcache
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop php
	@docker-compose -f ${APACHE_COMPOSE_FILE} start php

enable-opcache: ## Résactiver opcache
	$(CONNECT_SERVER_ROOT) mv /usr/local/etc/php/conf.d/dis_opcache /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop php
	@docker-compose -f ${APACHE_COMPOSE_FILE} start php

xdebug-enable: ## Activer xdebug
	$(CONNECT_SERVER_ROOT) mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop server
	@docker-compose -f ${APACHE_COMPOSE_FILE} start server

xdebug-disable: ## Désactiver xdebug
	$(CONNECT_SERVER_ROOT) mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop server
	@docker-compose -f ${APACHE_COMPOSE_FILE} start server

xdebug-install: ## Installer xdebug
	@echo "Install xdebug"
	$(CONNECT_SERVER_ROOT) pecl install xdebug && docker-php-ext-enable xdebug
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop server
	@docker-compose -f ${APACHE_COMPOSE_FILE} start server

xdebug-replace-ini: ## Init xdebug.
	@echo "Replace xdebug.ini"
	@docker cp ./.docker/apache/apache/xdebug/xdebug.ini $(COMPOSE_PROJECT_NAME)_server:/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
	@docker-compose -f ${APACHE_COMPOSE_FILE} stop server
	@docker-compose -f ${APACHE_COMPOSE_FILE} start server

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
