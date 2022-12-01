#!/bin/sh

# do not change
USER=ops
APP_DIR=consumer
NODE_HOME=$HOME/.consumer
CONFIG_DIR=$NODE_HOME/config
KEYS_DIR=consumer/keys
NODE_KEY_FILE=$KEYS_DIR/node_key.json
PRIV_VAL_KEY_FILE=$KEYS_DIR/priv_validator_key.json

# change this
CHAIN_BIN=oriond
CHAIN_ID=mib-orion
PERSISTENT_PEERS=""
GENESIS_URL=
DENOM=uorion
NODE_MONIKER=mib
VALIDATOR_AMOUNT=1000000

genesis_init () {
    if [ -n "$GENESIS_URL" ];
    then
        echo "Downloading genesis file..."
        if curl -fs $GENESIS_URL -o $CONFIG_DIR/genesis.json;
        then
            echo "Genesis downloaded!"
        else
            echo -e | "Failed to download genesis from url"
            exit
        fi;
    fi
}

chain_init () {
    echo "Initializing home directory ..."

    if [ ! -f "$NODE_KEY_FILE" ]; then
        echo "$NODE_KEY_FILE does not exist."
        exit
    fi
    if [ ! -f "$PRIV_VAL_KEY_FILE" ]; then
        echo "$PRIV_VAL_KEY_FILE does not exist."
        exit
    fi

    echo "Restoring keys files..."
    cp $NODE_KEY_FILE $NODE_HOME/config/priv_validator_key.json
    cp $PRIV_VAL_KEY_FILE $NODE_HOME/config/node_key.json
    
    echo | $CHAIN_BIN init -o --chain-id=$CHAIN_ID --home $NODE_HOME $NODE_MONIKER

    genesis_init
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