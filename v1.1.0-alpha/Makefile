# Makefile to bootup the network, and do operations (channel, chaincode)

# mode of the network: solo, kafka, couchdb, event, dev
HLF_MODE ?= kafka
HLF_VERSION ?= 1.1.0-alpha

CODE_BUILD_WAIT=40 # time to wait to build peer/orderer from local code
NETWORK_INIT_WAIT=240 # time to wait the fabric network finish initialization

COMPOSE_FILE ?= "swarm_fabric.yaml"

LOG_PATH ?= kafka/logs

all: test

test:
	@echo "Run test with $(COMPOSE_FILE)"
	@echo "Please make sure u have setup Docker and pulled images by 'make setup'."

	make ready  # Finish all testing

	make stop clean

ready: # create/join channel, install/instantiate cc
	make stop
	
	@echo "********* First step : Generate artifacts *********"

	make gen_config  # Will ignore if local config path exists
	make data_hyperledger
		
	@echo "********* Second step : Network Init ********* "
	make start
	@echo ""********* Waiting for network init...********* "
	@sleep ${NETWORK_INIT_WAIT}

	@echo "********* Create channel "businesschannel ********* "
	make test_channel_create
	make test_channel_join
	make update_anchors

	@echo "********* Install, instantiate and test chaincode "********* "
	make test_cc_install
	make test_cc_instantiate
	make test_cc_invoke_query

	make test_lscc # test lscc operations
	make test_qscc # test qscc operations

	make test_fetch_blocks # fetch block files

	make test_config_update # not work with this version
	make test_channel_update # not work with this version

	make test_fetch_blocks # fetch block files again
	make test_configtxlator

	make logs_save

	@echo "********* Now the fabric network is ready to play *********"
	@echo "********* run 'make cli' to enter into the fabric-cli container *********"
	@echo "********* run 'make stop' when done *********"

restart: stop start

data_hyperledger: # create data_hyperledger container 
	bash ./data_hyperledger.sh

start: # bootup the fabric network
	@echo "Start a fabric network with ${COMPOSE_FILE}..."
	@make clean
	@docker stack deploy -c swarm_fabric.yaml fabric

stop: # stop and kill the fabric network
	@echo "Stop the fabric network with ${COMPOSE_FILE}..."
	@docker stack rm fabric

################## Channel testing operations ################

test_channel_create: # Init the channel
	@echo "Create channel on the fabric network"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_channel_create.sh"

test_channel_join: # Init the channel
	@echo "Join channel"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_channel_join.sh"

update_anchors: # Update the anchor peer
	@echo "Update anchors on the fabric network"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_update_anchors.sh"

test_channel_update: # send the channel update transaction
	@echo "Test channel update with adding new org"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_channel_update.sh"

################## Configtxlator testing operations ################
test_configtxlator: # Test change config using configtxlator
	bash scripts/test_configtxlator.sh kafka; \
	
test_config_update: # Test change config to add new org
	bash scripts/test_config_update.sh kafka; \
	
################## Chaincode testing operations ################

test_cc_install: # Install the chaincode
	@echo "Install chaincode on the fabric network"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_cc_install.sh"

test_cc_instantiate: # Instantiate the chaincode
	@echo "Instantiate chaincode on the fabric network"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_cc_instantiate.sh"

test_cc_upgrade: # Upgrade the chaincode
	@echo "Upgrade chaincode on the fabric network"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_cc_upgrade.sh"

test_cc_invoke_query: # test user chaincode on all peers
	@echo "Invoke and query cc example02 on all peers"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_cc_invoke_query.sh"

test_qscc: # test qscc queries
	@echo "Test QSCC query"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash -c "cd /tmp; bash scripts/test_qscc.sh"

test_lscc: # test lscc quries
	@echo "Test LSCC query"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q)  bash -c "cd /tmp; bash scripts/test_lscc.sh"

# FIXME: docker doesn't support wildcard in cp right now
test_fetch_blocks: # test fetching channel blocks fetch
	@echo "Test fetching block files"
	@docker exec -it fabric_cli.1.$$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q)  bash -c "cd /tmp; bash scripts/test_fetch_blocks.sh"

################## Env setup related, no need to see usually ################

setup: # setup the environment
	bash scripts/env_setup.sh # Installing Docker and Docker-Compose
	bash scripts/download_images.sh # Pull required Docker images

check: # Check shell scripts grammar
	@echo "Check shell scripts grammar"
	[ `which shellcheck` ] && shellcheck scripts/*.sh

clean: # clean up containers
	@echo "Clean all HLF containers and chaincode images"
	@-docker ps -a | awk '{ print $$1,$$2 }' | grep "hyperledger/fabric" | awk '{ print $$1 }' | xargs -r -I {} docker rm -f {}
	@-docker ps -a | awk '$$2 ~ /dev-peer/ { print $$1 }' | xargs -r -I {} docker rm -f {}
	@-docker images | awk '$$1 ~ /dev-peer/ { print $$3 }' | xargs -r -I {} docker rmi -f {}


env_clean: # clean up environment
	@echo "Clean all images and containers"
	bash scripts/env_clean.sh

cli: # enter the cli container
	docker exec -it fabric_cli.1.$(docker service ps -f 'name=fabric_cli.1' fabric_cli -q) bash

orderer: # enter the orderer container
	docker exec -it fabric_orderer.1.$(docker service ps -f 'name=fabric_orderer.1' fabric_orderer -q) bash

peer: # enter the peer container
	docker exec -it fabric_peer0_org1_example_com.1.$(docker service ps -f 'name=fabric_peer0_org1_example_com.1' fabric_peer0_org1_example_com -q) bash

ps: # show existing docker images
	docker ps -a

gen_config: # generate config artifacts
	bash scripts/gen_config.sh kafka; \

download: # download required images
	@echo "Download Docker images"
	bash scripts/download_images.sh

