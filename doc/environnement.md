#Environnement

Un environnement de dev par défaut est fourni : 
- MariaDB
- PHP 7.4
- adminer (http://adminer.games_api.localhost/?server=mariadb&username=games_api&db=games_api)


## Pré-requis : 
- make, c'est plus simple
- docker
- docker-compose

## Installation
1. Copier/coler le fichier .env.example en .env et en modifiant les données WEB_GID et WEB_UID
1. Lancez la commande `make all-up`
2. Normalement c'est tout.
3. Créer une db avec `make db-create` si le coeur vous en dit.

## Outils
Lancez la commande `make help` pour voir les commandes utiles.

