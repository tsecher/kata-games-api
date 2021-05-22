##
#############################    ENV TRAEFIK    #####################################

TRAEFIK_DIR = '.'

NETWORK = traefik-net

traefik-create-network: ## Création du network
	- docker network create ${NETWORK}

traefik-up: ## Lance le réseau Traefik
	make traefik-create-network
	@docker-compose -f ${TRAEFIK_COMPOSE_FILE} up -d

traefik-stop: ## Arrête et supprime l’ensemble des éléments décrits dans le fichier de configuration de l'environnement traefik (hors volumes)
	@docker-compose -f ${TRAEFIK_COMPOSE_FILE} stop

traefik-config: ## Valide la configuration du docker-compose-traefik
	@docker-compose -f ${TRAEFIK_COMPOSE_FILE} config
