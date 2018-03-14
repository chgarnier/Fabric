# Comment déployer et manager un réseau blockchain Hyperledger Fabric avec Docker Swarm

Vous trouverez ici l'ensemeble des éléments et explications nécessaires au déploiement d'Hyperledger Fabric sur plusieurs machines distantes. Nous utilisons pour cela Docker Swarm afin de gérer et de manager l'insfrastructure blockchain. 

De nombreux éléments et scripts provient d'ici : https://github.com/yeasy/docker-compose-files/tree/master/hyperledger_fabric. 

Dans notre exemple, nous allons déployer un résau Hyperledger FABRIC composé de :
  - 2 organisations possèdant chacune deux noeuds, une autorité de certification et un noeud orderer
  - d'un consensus de type kafka dont les noeuds sont répartis entre les 2 organisations
  - de l'explorateur de blockchain Hyperledger Explorer

# Etape à suivre

1) Configuration du réseau docker swarm 

2) Mise en place d'un serveur NFS sur le master SWARM

3) Génération matériel cryptographique

4) Déploiement du réseau

5) Test de bon fonctionnement du réseau
