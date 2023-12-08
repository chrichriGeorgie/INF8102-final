<!-- TABLE DES MATIÈRES-->
<details>
  <summary>Table des matières</summary>
  <ol>
    <li><a href="#construit avec">Construit avec</a></li>
    <li><a href="#contenu du dossier benchmark">Contenu du dossier benchmark</a></li>
    <li><a href="#Contenu du dossier server">Contenu du dossier server</a></li>
    <li><a href="#contenu du dossier terraform-deployment">Contenu du dossier terraform-deployment</a></li>
    <li><a href="#commandes pour reproduire">Commandes pour reproduire</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#remerciements">Remerciements</a></li>
  </ol>
</details>

# INF8102-final
Repo pour le projet final du cours INF8102.

## Construit avec
* AWS CLI
* Python 3
* Terraform
* DynamoDB
* Docker
* Bash

### Contenu du dossier benchmark
Contient les scripts utilisés afin de performer les tests d'intrusion automatique.
Le script fait l'exécution des outils suivants:
* nmap
* Masscan
* Hydra
* Stress-tester

Il va produire un fichier de résultat par outil. Aussi, pour Hydra, il faut fournir une liste d'utilisateurs "users.txt" et une liste de mot de passe "dict.txt". 

### Contenu du dossier server
Contient le script et les configurations pour le serveur C2, le client (virus) et l'image Docker pour le déploiement du serveur.

### Contenu du dossier terraform-deployment
Contient les fichiers Terraform décrivant l'infrastructure, le code Python servant à la lambda, un script Bash de déploiement sur les instances EC2 et un script Bash d'orchestration du déploiement. La sortie du déploiment terraform contiendra l'adresse URL de la fonction Lambda, cette adresse est nécessaire pour tester le déploiement.

### Commandes pour reproduire 
* Installer les outils et les dépendances (voir les sections Construit Avec et Benchmark)
#### Déploiement
* cd terraform-deployment
* ./deploy.sh et suivre les instructions
#### Test du déploiment
* Ouvrir une fenetre bash
* cd server
* vim client.py
* changer url par l'adresse de la fonction lambda
* :wq
* python3 client.py
#### Expérimentation
* Ouvrir une fenêtre bash
* cd benchmark
* ./launch-benchmark.sh
* ./http-dos-benchmark.sh
  
### Contact
Jimmy Bell   
Cédrick Gontran Nicolas  
Celina Ghoraieb-Munoz  
Christophe St-Georges  

### Remerciements
* [A Thousand Sails, One Harbor - C2 Infra on Azure](https://0xdarkvortex.dev/c2-infra-on-azure/)

