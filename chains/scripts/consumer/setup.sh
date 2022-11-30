#!/bin/sh

# do not change
USER=ops
APP_DIR=consumer
NODE_HOME=$HOME/.consumer
CONFIG_DIR=$NODE_HOME/config

# change this
CHAIN_BIN=stranged
CHAIN_ID=strange-1
PERSISTENT_PEERS=""
GENESIS_URL=
DENOM=ustrange
NODE_MONIKER=node_moniker
VALIDATOR_AMOUNT=1000000
MNEMONIC=""

genesis_init () {
    if [ -n "$GENESIS_URL" ];
    then
        echo "Downloading genesis file..."
        if curl -fs $GENESIS_URL -o $CONFIG_DIR/genesis.json;
        then
            echo "Genesis downloaded!"
        else
            echo -e | "Failed to download genesis from url"
            echo "Check genesis url or remove it to start from local genesis file."
            exit
        fi;
    else
        echo "No remote genesis url provided. Starting from local genesis file"
    fi
}

chain_init () {
    echo "Initializing home directory ..."

    if [ ! -n "$MNEMONIC" ]
        then
            echo -e | "No MNEMONIC provided. Set your validator mnemonic and retry."
            exit
        else
            echo $MNEMONIC | $CHAIN_BIN init -o --chain-id=$CHAIN_ID --home $NODE_HOME --recover $NODE_MONIKER
    fi

    genesis_init

    # echo "Restoring keys files..."
    # cp /$APP_DIR/keys/priv_validator_key.json $NODE_HOME/config/priv_validator_key.json
    # cp /$APP_DIR/keys/node_key.json $NODE_HOME/config/node_key.json
    
}

if [ ! -d $CONFIG_DIR ]
then
    echo "Init chain config..."

    chain_init
fi

if [ -d $NODE_HOME ]
then
    if [ -n "$PERSISTENT_PEERS" ];
    then
        echo | $CHAIN_BIN start --x-crisis-skip-assert-invariants --home $NODE_HOME --p2p.persistent_peers $PERSISTENT_PEERS &

        wait
    else
        echo | $CHAIN_BIN start --x-crisis-skip-assert-invariants --home $NODE_HOME &

        wait
    fi
    
fi