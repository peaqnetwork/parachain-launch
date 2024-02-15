#!/bin/bash

KEEP_CHAIN=${KEEP_CHAIN:-"false"}
SURI=${SURI}

PARACHAIN_ID="3013"
PARACHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/dev-local-3013.json"
PARACHAIN_BOOTNODE="/ip4/127.0.0.1/tcp/31333/p2p/12D3KooWExYdFUvpfKee9W5B1Ybp8JQgKECf6TUVDdYsMmcYkFma"
RELAYCHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/rococo-local.json"
BINARY_PATH="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v0.0.15.moonbeam/peaq-node"
CHAIN_FOLDER="chain-folder-need-delete"

# main sub-libp2p: [Parachain] 🏷n  Local node identity is: 12D3KooWSKbKXoRM1Au6ycCQAAS6ESCMNLBkbEC84Zd9ysQXJsrD


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
  --parachain-id $PARACHAIN_ID \
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
