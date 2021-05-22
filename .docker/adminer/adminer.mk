##
#############################    ENV MariaDB    #####################################

ADMINER_DIR = '.'

adminer-up: ## Lance le réseau MARIADB
	@docker-compose -f ${ADMINER_COMPOSE_FILE} up -d

adminer-stop: ## Arrête et supprime l’ensemble des éléments décrits dans le fichier de configuration de l'environnement mariadb (hors volumes)
	@docker-compose -f ${ADMINER_COMPOSE_FILE} stop

