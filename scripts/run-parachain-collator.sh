#!/bin/bash

# Usage:
# SURI="AA BB CC" ./run-parachain-collator.sh

KEEP_CHAIN=${KEEP_CHAIN:-"false"}
SURI=${SURI}

TYPE="peaq"
VERSION="v0.0.6"
PARACHAIN_BOOTNODE="/ip4/127.0.0.1/tcp/40336/p2p/12D3KooWRGKzxojMtqPFdRT9d3oDKtJCfa2RHTS8sAp5uvE4SM7E"

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
