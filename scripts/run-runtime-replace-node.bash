#!/bin/bash

# Usage:
# ./scripts/run-runtime-replace-node.bash
# KEEP_CHAIN=false SYNC_PHASE=true bash ./scripts/run-runtime-replace-node.bash
# KEEP_CHAIN=true SYNC_PHASE=false bash ./scripts/run-runtime-replace-node.bash

KEEP_CHAIN=${KEEP_CHAIN:-"false"}
SYNC_PHASE=${SYNC_PHASE:-"false"}

TYPE="peaq"
VERSION="v0.0.101"
PARACHAIN_BOOTNODE="/ip4/127.0.0.1/tcp/40336/p2p/12D3KooWBDegsxofY7GkRUVd6r8WgbyTZMnFDmM7g1iESHwLrSNA"

if [ "$TYPE" == "peaq-dev" ]; then
  PARACHAIN_ID="2000"
  CONFIG_NAME="dev-local-${PARACHAIN_ID}.json"
elif [ "$TYPE" == "krest" ]; then
  PARACHAIN_ID="2241"
  CONFIG_NAME="krest-local-${PARACHAIN_ID}.json"
elif [ "$TYPE" == "peaq" ]; then
  PARACHAIN_ID="3338"
  CONFIG_NAME="peaq-local-${PARACHAIN_ID}.json"
else
  echo "Unknown parachain type: $TYPE"
  exit 1
fi

PARACHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/$CONFIG_NAME"
RELAYCHAIN_CONFIG="/home/jaypan/Work/peaq/parachain-launch/yoyo/rococo-local.json"
BINARY_PATH="/home/jaypan/PublicSMB/peaq-node-binary/peaq-node.${TYPE}.${VERSION}"
CHAIN_FOLDER="chain-folder-need-delete"

# main sub-libp2p: [Parachain] 🏷n  Local node identity is: 12D3KooWSKbKXoRM1Au6ycCQAAS6ESCMNLBkbEC84Zd9ysQXJsrD


if [ "${KEEP_CHAIN}" != "true" ]; then
  rm -rf $CHAIN_FOLDER
fi

if [ ! -d $CHAIN_FOLDER ]; then
  mkdir $CHAIN_FOLDER
fi

if [ "${SYNC_PHASE}" == "true" ]; then
  $BINARY_PATH \
    --parachain-id $PARACHAIN_ID \
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
elif [ "${SYNC_PHASE}" != "true" ]; then
  docker ps --format "{{.ID}} {{.Image}}" | grep "${PARACHAIN_ID}-0" | awk '{print $1}' | xargs docker kill

  RUST_LOG=xcm=trace \
  $BINARY_PATH \
    --parachain-id $PARACHAIN_ID \
    --chain $PARACHAIN_CONFIG \
    --port 50334 \
    --rpc-port 10044 \
    --base-path $CHAIN_FOLDER \
    --unsafe-rpc-external \
    --rpc-cors=all \
    --rpc-methods=Unsafe \
    --bootnodes $PARACHAIN_BOOTNODE \
    --node-key=f9b7c8373875db70a5319a11f5d85612a247b86014f38fae34500552ef82aa96 \
    --collator \
    --ferdie \
    -- \
    --chain $RELAYCHAIN_CONFIG \
    --port 50345 \
    --rpc-port 20055 \
    --unsafe-rpc-external \
    --rpc-cors=all

    # 12D3KooWRxmsc76n8Tfxn4eML55HuQz2ajsge6MoRubstFKJ9CgY
fi
