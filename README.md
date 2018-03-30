# Comment déployer et manager un réseau blockchain Hyperledger Fabric avec Docker Swarm

Vous trouverez ici l'ensemble des éléments et explications nécessaires au déploiement d'Hyperledger Fabric sur plusieurs machines distantes et sur des réseaux différents. 

Nous considérons ici les acteurs suivants : 
  - l'acteur qui déploie et manage le réseau blockhain Hyperledger Fabric : Opérateur.
  - les organisations participant au réseau blockchain Hyperledger Fabric : Org1, Org2, Org3, Org4.
  
Pour le déploiement et le management de l'insfrastructure blockchain nous utilisons Docker Swarm. L'opérateur a ainsi le rôle de manager du réseau Swarm et chacun des noeuds physiques des organisations ont le rôle d'un worker. Le réseau docker Swarm sera donc composé de 5 noeuds : 1 manager et 4 workers. 

Chacune des organisations possèdera : 
  - 2 peers qui maintiendront le ledger et permettront le déploiement du chaincode,
  - une autorité de certification,
  - une "interface command line" pour interagir avec les peers.
Ainsi 4 containeurs dockers seront déployés sur chacun des noeuds physiques des organisations. 

Le réseau Hyperledger Fabric comprendra également : 1 noeud orderer avec un consensus de type kafka délployé sur le manager et l'explorateur de blockchain Hyperledger Explorer. 

De nombreux éléments et scripts provient d'ici : https://github.com/yeasy/docker-compose-files/tree/master/hyperledger_fabric. 


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
