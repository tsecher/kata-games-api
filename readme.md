# GAMES API
####### Kata back

## Principe
Le but du kata est de construire une API permettant à des utilisateurs authentifiés 
d'ajouter leur score à des jeux de différents types et accéder à l'historique de leur parties.
Il s'agit donc de fournir une api correspondant au contrat d'interface décrit ci-dessous :

### Contrat d'interface :

- /user/signup:  
    - Description: Création d'utilisateur
    - Méthode: POST
    - Paramètres : 
        - login (string) : unique par utilisateur
        - mdp (string)
    - Retour : 
        - format : JSON,
        - structure : 
            ```json
                {
                    "userData": {
                        "id": {{identifiant}},
                        "login": {{login}}
                    }
                }
            ```
    
- /user/signin
    - Description: Connexion d'un utilisateur
    - Méthode: POST
    - Paramètres :
        - login (string) : unique par utilisateur
        - mdp (string)
    - Retour :
        - format : JSON,
        - structure :
            ```json
                {
                    "userData": {
                        "id": {{identifiant}},
                        "login": {{login}}
                    }
                }
            ```

- /user
    - Description: Récupération des données de l'utilisateur connecté
    - Méthode: GET
    - Retour :
        - format : JSON,
        - structure :
            ```json
                {
                    "userData": {
                       "login": {{login}}
                    }
                }
            ```


- /party/types
    - Description: Récupération de la liste des types de jeux dispo.
    - Méthode: GET
    - Retour :
        - format : JSON,
        - structure :
            ```json
                {
                    "types": [
                        {
                            "title": "Chifoumi",
                            "id": "{{identifiant}}",
                            "description": "Jeu du chifoumi",
                        }
                    ],
                    ...
                } 
            ```

- /party/history
    - Description: Récupération de la liste de tous les scores du joueur connecté.
    - Méthode: GET
    - Retour :
        - format : JSON,
        - structure :
            ```json
                {
                    "history": [
                        {
                            "type": {{identifiant de type de partie}},
                            "score": "{{ score }}",
                            "date": "{{ date (U) }}"
                        },
                        ...
                    ]     
                }
            ```

- /party/history/{{type}}
    - Description: Récupération de la liste des scores du type de partie {{type}} de l'utilisateur connecté.
    - Méthode: GET
    - Retour :
        - format : JSON,
        - structure :
            ```json
                {
                   "history": [
                        {
                            "type": {{identifiant de type de partie}},
                            "score": "{{score}}",
                            "date": "{{date (U) }}"
                        },
                        ...
                    ]     
                }
            ```

## Environnement de dev.
Un environnement de dev docker est à dispo.
On peut l'utiliser ou pas. Si on ne l'utilise pas, il faut décrire la documentation de mise en place 
de l'environnement.
- [Documentation de l'environnement](./doc/environnement.md)




````
