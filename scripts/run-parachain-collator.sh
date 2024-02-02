#!/bin/bash

KEEP_CHAIN=${KEEP_CHAIN:-"false"}
SURI=${SURI}

PARACHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/dev-local-2000.json"
PARACHAIN_BOOTNODE="/ip4/127.0.0.1/tcp/40336/p2p/12D3KooWBD8acxfoqmVzC3eu7XqrQdvh7TMF1LW2PQtWRTjTVZBR"
RELAYCHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/rococo-local.json"
BINARY_PATH="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v0.0.10/peaq-node"
CHAIN_FOLDER="chain-folder-need-delete"

if [ KEEP_CHAIN != "true" ]; then
  rm -rf $CHAIN_FOLDER
fi

if [ ! -d $CHAIN_FOLDER ]; then
  mkdir $CHAIN_FOLDER
fi

$BINARY_PATH \
  key insert \
  --base-path $CHAIN_FOLDER \
  --chain $PARACHAIN_CONFIG \
  --scheme Sr25519 \
  --suri "$SURI" \
  --key-type aura

$BINARY_PATH \
  --parachain-id 2000 \
  --collator \
  --chain $PARACHAIN_CONFIG \
  --port 50334 \
  --rpc-port 20044 \
  --base-path $CHAIN_FOLDER \
  --unsafe-rpc-external \
  --rpc-cors=all \
  --rpc-methods=Unsafe \
  --execution wasm \
  --bootnodes $PARACHAIN_BOOTNODE \
  -- \
  --execution wasm \
  --chain $RELAYCHAIN_CONFIG \
  --port 50345 \
  --rpc-port 20055 \
  --unsafe-rpc-external \
  --rpc-cors=all
