# Copie des données nécessaires pour l'initialisation de réseau blockchain Hyperledger
# Script à exécuter sur le manager
# Les données sont copiées dans le répertoire /data_hyperledger/fabric du manager puis le container docker "data_hyperledger" est déployé sur le manager sur le réseau Swarm overlay Fabric.

# Suppression des données anciennes ou concernant une autre blockchain managée par le même opérateur
sudo rm -rf /data_hyperledger/fabric
sudo mkdir -p /data_hyperledger/fabric

# Copie du matériel nécessaire
sudo cp -rf * /data_hyperledger/fabric
sudo cp -rf ./kafka/channel-artifacts/* /data_hyperledger/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/.
sudo mkdir /data_hyperledger/fabric/explorer-artifacts/first-network/
sudo mkdir /data_hyperledger/fabric/explorer-artifacts/first-network/crypto-config
sudo cp -rf ./crypto-config/* /data_hyperledger/fabric/explorer-artifacts/first-network/crypto-config/.

# Droits pour les conteneurs (à vériier si nécessaire)
sudo chmod -R +666 /data_hyperledger/fabric


# Déploiement du containeur docker "data_hyperledger"
docker run --ip 10.0.0.242 --name data_hyperledger --network=fabricnet -d -p 20-21:20-21 -p 65500-65515:65500-65515 -v /data_hyperledger/fabric:/var/ftp:ro inanimate/vsftpd-anon
