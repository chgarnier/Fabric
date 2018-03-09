rm -rf /nfs/fabric
mkdir /nfs/fabric
cp -rf * /nfs/fabric
cp -rf ./kafka/channel-artifacts/* /nfs/fabric/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/.


chmod -R +666 /nfs/fabric
