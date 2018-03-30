# Permet de visualiser l'état des noeuds du cluster Swarm
# Commande à lancer sur le manager du cluster Swarm
docker run -it -d -p 5000:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer 

