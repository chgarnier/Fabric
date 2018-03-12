rm -rf /nfs/fabric
mkdir /nfs/fabric
cp -rf * /nfs/fabric
cp -rf ./kafka/channel-artifacts/* /nfs/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/.
mkdir /nfs/fabric/explorer-artifacts/first-network/
mkdir /nfs/fabric/explorer-artifacts/first-network/crypto-config
cp -rf ./crypto-config/* /nfs/fabric/explorer-artifacts/first-network/crypto-config/.

chmod -R +666 /nfs/fabric
