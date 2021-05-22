include .docker/apache/apache.mk
include .docker/traefik/traefik.mk
include .docker/mariadb/mariadb.mk
include .docker/adminer/adminer.mk


all-up: ## All up
	- make traefik-up
	- make mariadb-up
	- make up
	- make adminer-up


all-stop: ## All up
	- make stop
	- make mariadb-halt
	- make traefik-halt
	- make adminer-halt
