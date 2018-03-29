# Comment déployer et manager un réseau blockchain Hyperledger Fabric avec Docker Swarm

Vous trouverez ici l'ensemeble des éléments et explications nécessaires au déploiement d'Hyperledger Fabric sur plusieurs machines distantes et sur des réseaux différents. Nous utilisons pour cela Docker Swarm afin de gérer et de manager l'insfrastructure blockchain. De nombreux éléments et scripts provient d'ici : https://github.com/yeasy/docker-compose-files/tree/master/hyperledger_fabric. 


Dans notre exemple, nous allons déployer un résau Hyperledger FABRIC composé de :
  - 3 organisations possèdant chacune deux peer, une autorité de certification et un peer "command line" qui seront localisés sur le même noeud physique. 
  - 1 noeud orderer avec un consensus de type kafka,
  - l'explorateur de blockchain Hyperledger Explorer.

Le réseau docker Swarm sera lui composé de 5 noeuds : 1 manager et 4 workers (un par organisation et un pour l'orderer). 

# Etape à suivre

## Configuration des ports 

Pour l'utilisation de docker Swarm, les ports suivant doivent être ouverts et/ou forwarder vers l'IP local de votre noeud :

- TCP port 2377  pour le management du cluster 
- TCP et UDP port 7946 
- UDP port 4789 pour le traffic réseau VXLAN overlay


## Configuration du réseau docker swarm 


### Swarm init 
Sur le noeud qui jouera le rôle du manager du réseau Swarm :

```bash
docker swarm init --advertise-addr 185.6.xx.xx
```
Il faut remplacer 185.6.xx.xx par l'adresse IP publique du manager. Docker Swarm renvoie alors quelque chose du type : 

```bash
docker swarm join --token SWMTKN-1-0dnph4r0j3cbhe5vjx229h2snhkpoz5b62yt90vr3zcd9u-c21usha26jo42xkvx8sozpmn 185.6.xxx.xxx:2377
```

### Swarm join  
Les noeuds jouant le rôle de worker vont ensuite rejoindre le réseau Swarm par la commande : 

```bash
docker swarm join --token SWMTKN-1-0dnph4r0j3cbhe5vjx229h2snhkpoz5b62yt90vr3zcd9u-c21usha26jo42xkvx8sozpmn --advertise-addr xx.xx.xx.xx 185.6.xxx.xxx:2377
```
Il faut remplacer xx.xx.xx.xx par l'adresse IP publique du worker.

### Swarm network
Il noous faut maintenant créer le réseau swarm sur lequel communiqueront les containeurs docker. 

```bash
docker network create --attachable --driver overlay fabric
```

2) Mise en place d'un serveur NFS sur le master SWARM

3) Génération matériel cryptographique

4) Déploiement du réseau

5) Test de bon fonctionnement du réseau
