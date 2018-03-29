# Comment déployer et manager un réseau blockchain Hyperledger Fabric avec Docker Swarm

Vous trouverez ici l'ensemeble des éléments et explications nécessaires au déploiement d'Hyperledger Fabric sur plusieurs machines distantes et sur des réseaux différents. Nous utilisons pour cela Docker Swarm afin de gérer et de manager l'insfrastructure blockchain. De nombreux éléments et scripts provient d'ici : https://github.com/yeasy/docker-compose-files/tree/master/hyperledger_fabric. 


Dans notre exemple, nous allons déployer un résau Hyperledger FABRIC composé de :
  - 3 organisations possèdant chacune deux noeuds, une autorité de certification
  - 1 noued orderer avec un consensus de type kafka
  - l'explorateur de blockchain Hyperledger Explorer

# Etape à suivre

## Configuration des ports 

Pour docker Swarm, les ports suivant doivent être ouverts et/ou forwarder vers l'IP local de votre noeud :

- TCP port 2377  pour le management du cluster 
- TCP et UDP port 7946 
- UDP port 4789 pour le traffic réseau VXLAN overlay


## Configuration du réseau docker swarm 



2) Mise en place d'un serveur NFS sur le master SWARM

3) Génération matériel cryptographique

4) Déploiement du réseau

5) Test de bon fonctionnement du réseau
