##
#############################    ENV MariaDB    #####################################

MARIADB_DIR = '.'
NETWORK = mariadb

mariadb-create-network: ## Création du network
	- docker network create ${NETWORK}

mariadb-up: ## Lance le réseau MARIADB
	make mariadb-create-network
	@docker-compose -f ${MARIADB_COMPOSE_FILE} up -d

mariadb-stop: ## Arrête et supprime l’ensemble des éléments décrits dans le fichier de configuration de l'environnement mariadb (hors volumes)
	@docker-compose -f ${MARIADB_COMPOSE_FILE} stop

mariadb-config: ## Valide la configuration du docker-compose-traefik
	@docker-compose -f ${MARIADB_COMPOSE_FILE} config
