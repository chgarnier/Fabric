# Comment déployer et manager un réseau blockchain Hyperledger Fabric avec Docker Swarm

Vous trouverez ici l'ensemble des éléments et explications nécessaires au déploiement d'Hyperledger Fabric sur plusieurs machines distantes et sur des réseaux différents. 

Nous considérons ici les acteurs suivants : 
  - l'acteur qui déploie et manage le réseau blockhain Hyperledger Fabric : Opérateur.
  - les organisations participant au réseau blockchain Hyperledger Fabric : Org1, Org2, Org3, Org4.
  
Pour le déploiement et le management de l'insfrastructure blockchain nous utiliserons Docker Swarm. L'opérateur a ainsi le rôle de manager du cluster Swarm et chacun des noeuds physiques des organisations ont le rôle d'un worker. Le cluster docker Swarm sera donc composé de 5 noeuds : 1 manager et 4 workers. 

Chacune des organisations possèdera : 
  - 2 peers qui maintiendront le ledger et permettront le déploiement du chaincode,
  - une autorité de certification,
  - une "interface command line" pour interagir avec les peers.
Ainsi 4 containeurs dockers seront déployés sur chacun des noeuds physiques des organisations. 

Le réseau Hyperledger Fabric comprendra également : 1 noeud orderer avec un consensus de type kafka délployé sur le manager et l'explorateur de blockchain Hyperledger Explorer. 

Les containeurs docker qui seront déployés communiqueront entre eux via un réseau virtuel swarm de type overlay. 

De nombreux éléments et scripts provient d'ici : https://github.com/yeasy/docker-compose-files/tree/master/hyperledger_fabric. 

# Etape à suivre

## Configuration des ports 
Pour l'utilisation de docker Swarm, les ports suivant doivent être ouverts et/ou forwarder de l'IP publique vers l'IP local du noeud :

- TCP port 2377  pour le management du cluster 
- TCP et UDP port 7946 
- UDP port 4789 pour le traffic réseau VXLAN overlay

## Configuration des noeuds participant au cluster Swarm

Installer la dernière version de docker sur les noeuds worker et le manager: https://docs.docker.com/install/linux/docker-ce/ubuntu/#extra-steps-for-aufs.

Sur chacun des workers (noeuds à partir desquels des chaincodes seront déployés), il nous faut configurer le deamon docker afin qu'il écoute sur le socket lié à l'adresse l'IP local du noeud worker : 
```bash
sudo dockerd -H unix:///var/run/docker.sock -H tcp://192.168.59.106
```
Il faut 192.168.59.106 par l'adresse IP local du worker. Cette configuration est nécessaire car un chaincode vit dans un container docker propre. Ainsi le chaincode n'a pas un accès direct au ledger qui est sur le peer. Le container docker "peer" déployant ce chaincode va donc déployer un container docker sur le worker concerné, il faut donc qu'il puisse avoir accès au deamon docker du worker. 

## Configuration du cluster docker swarm 
Il nous faut maintenant créer un cluster docker swarm.

### Initiation du cluster par l'opérateur
Sur le noeud qui jouera le rôle du manager du cluster Swarm :

```bash
docker swarm init --advertise-addr 185.6.xx.xx
```
Il faut remplacer 185.6.xx.xx par l'adresse IP publique du manager. Docker Swarm renvoie alors la commande permettant au noeud worker de rejoindre le cluster Swarm : 

```bash
docker swarm join --token SWMTKN-1-0dnph4r0j3cbhe5vx229h2nhkpoz5b62yt0vr3zc9u1usha26jo42xkvx8sozpmn 185.6.xxx.xxx:2377
```

### Rejoindre le cluster swarm  
Chacun des noeuds physiques des organisations jouant le rôle de worker doit ensuite rejoindre le cluster Swarm par la commande : 

```bash
docker swarm join --token SWMTKN-1-0dnph4r0j3cbhe5vjx229h2snhkpoz5b62yt90vr3zcd9u-c21usha26jo42xkvx8sozpmn --advertise-addr xx.xx.xx.xx 185.6.xxx.xxx:2377
```
Il faut remplacer xx.xx.xx.xx par l'adresse IP publique du worker et 185.6.xxx.xxx poar l'adresse IP publique du manager. 

### Création du réseau virtuel VXLAN

Il nous faut maintenant créer le réseau swarm sur lequel communiqueront de manière sécurisée les containeurs docker. 

```bash
docker network create --attachable --driver overlay fabric
```
Pour plus d'informations sur les réseaux overlay sous Docker Swarm : https://docs.docker.com/network/overlay/

## Configuration du réseau Hyperledger Fabric

Dans un premier temps il faut télécharger sur le manager du réseau Swarm le dossier https://github.com/chgarnier/Fabric/tree/master/v1.1.0-alpha. 

Si vous souhaitez changer le nombre d'organisations et la configuration du réseau il vous faudra effectuer les changements ici  https://github.com/chgarnier/Fabric/blob/master/v1.1.0-alpha/crypto-config.yaml et ici  https://github.com/chgarnier/Fabric/blob/master/v1.1.0-alpha/kafka/configtx.yaml.

### Génération matériel cryptographique
La première étape pour le déploiement du réseau Hyperledger Fabric consiste dans la génération du matériel cryptographique pour chacun des noeuds des organisations, des autorités de certification et de l'orderer. 

La commande suivante génère le matériel crytptographique à partir des fichiers de configuration crypto-config.yaml et configtx.yaml :
```bash
make gen_config
```
Suite à cette commande le matériel cryptographique généré se trouvera dans le dossier crypto-config et les fichiers de configuration du channel dans le dossier kafka/channel-artifacts.

### 
Comme chacun des containeurs docker aura besoin d'obtenir son matériel cryptographique, nous passons par un container docker "data" auquel chacun des containers docker du réseau Swarm peut accèder en ftp. Chacun des containeurs dockers télécharge ainsi le matériel cryptographique qui lui est propre. 

Pour lancer le container docker "data"
```bash
./data.sh
```
Une fois que l'ensemble du réseau hyperledger fabric sera initialisé ce container docker "data" peut être détruit. 

### Déploiement du réseau Hyperledger Fabric sur le cluster Swarm

Pour déployer les différents containeurs docker sur les workers :
```bash
make start
```

### Création d'un nouveau channel 
La commande suivante permet la création d'un channel dont le nom sera buisinesschannel.
```bash
make test_channel_create
```
Pour que l'ensemble des noeuds du réseau rejoigne le channel : 
```bash
make test_channel_join
```

### Installation, instantiation et test d'un chaincode
On peut ensuite installer un chaincode "test"
```bash
make test_cc_install
```
Puis l'instancier :
```bash
make test_cc_instantiate
```
Et finalement tester les invoke et query de ce chaincode
```bash
make test_cc_invoke_query
```

## Nous voilà avec un réseau blockchain Hyperledger Fabric sur plusieures machines distantes, sur différents réseaux et avec un managemement du réseau via docker Swarm.
