# Docker bundle to run ICS consumer chain
> based on mib-orion consumer chain from GoC 2022

This repository contains:
```bash
# Chains
  * consumer-chain v0.1.0
  * Hermes Relayer v1.0.0
```

&nbsp;

# Prerequisites
- [`Docker`](https://www.docker.com/)
- [`docker-compose`](https://github.com/docker/compose)

## Install Docker Utility
If running on linux, you can install these tools with the following commands:

- docker
```
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt install docker.io -y
```
- docker-compose
```
sudo apt install docker-compose -y
```
&nbsp;

# Run consumer chain
## Update configs before running chain
> you can find all info needed for this chain [`here`](https://github.com/made-in-block/ics-testnets/tree/main/game-of-chains-2022/orion) 

1. Edit docker-compose.yml file::

```sh
# change this
  - CHAIN_BIN=oriond
  - GIT_REPO=https://github.com/made-in-block/mib-consumer-chain.git
  - GIT_BRANCH=v0.1.0
```

2. Edit variables on chains/scripts/consumer/setup.sh file::

```sh  
# change this
  CHAIN_BIN=oriond
  CHAIN_ID=mib-orion
  PERSISTENT_PEERS=""
  GENESIS_URL=
  DENOM=uorion
  NODE_MONIKER=node_moniker
  VALIDATOR_AMOUNT=1000000
  MNEMONIC=""
```

3. Copy your node_key.json and priv_validator_key.json from provider chain in `chains/keys` folder

&nbsp;

## Start, stop, and reset `consumer` chain

- Start `consumer`:

```sh
make start
```

Your environment now contains:
```bash
# consumer endpoints
  RPC http://localhost:29657
  API http://localhost:1917
  GRPC http://localhost:9990
## you can change exposed ports on docker-compose.yml
```

Stop `all` (and **retain** chain data):

```sh
make stop
```

Stop `all` (and **delete** chains data):

```sh
make reset
```

Stop `all` and `delete` containers (**delete** chains data and containers):

```sh
make delete
```

&nbsp;

## Modifying node configuration

You can modify the node configuration of your validator in the `chains/data/consumer/config/config.toml` and `chains/data/consumer/config/app.toml` files after the first chain run.
* remember to stop the container before making changes *

