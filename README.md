<!-- TABLE DES MATIÈRES-->
<details>
  <summary>Table des matières</summary>
  <ol>
    <li><a href="#construit avec">Construit avec</a></li>
    <li><a href="#benchmark">Benchmark</a></li>
    <li><a href="#server">Server</a></li>
    <li><a href="#terraform-deployment">terraform-deployment</a></li>
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

### Benchmark
Contient les scripts utilisés afin de performer les tests d'intrusion automatique.
Le script fait l'exécution des outils suivants:
* nmap
* Masscan
* Hydra
* Stress-tester
  
### Server
Contient le script et les configurations pour le serveur C2, le client (virus) et l'image Docker pour le déploiement du serveur.

### terraform-deployment
Contient les fichiers Terraform décrivant l'infrastructure, le code Python servant à la lambda, un script Bssh de déploiement sur les instances EC2 et un script  Bash d'orchestration du déploiement

### Contact
Jimmy Bell - jimmy.bell@polymtl.ca  
Cédrick Gontran Nicolas - cedrick.nicolas@polymtl.ca  
Celina Ghoraieb-Munoz - celina.ghoraieb-munoz@polymtl.ca  
Christophe St-Georges - christophe.st-georges@polymtl.ca  

### Étapes de reproduction

*Installer les outils et les dépendances (voir la section Construit Avec)
  *Deploiement
* cd terraform-deployment
* ./deploy.sh et suivre les instructions
* Expérimentation
* Ouvrir une deuxième fenêtre bash
* cd benchmark
* ./launch-benchmark.sh
* ./http-dos-benchmark.sh

### Remerciements
* [A Thousand Sails, One Harbor - C2 Infra on Azure](https://0xdarkvortex.dev/c2-infra-on-azure/)

