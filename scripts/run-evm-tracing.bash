#!/bin/bash

# Description: Run the parachain node with the EVM tracing enabled
# Usage: ./run-evm-tracing.sh
BINARY_POSITION="/home/jaypan/Work/peaq/peaq-network-node/target/release/peaq-node"

TYPE="peaq-dev"
PARACHAIN_BOOTNODE="/ip4/127.0.0.1/tcp/40336/p2p/12D3KooWNrrmuMiMykgvQBeYhMZ2AHX7WTXYcacwRnpT8nJC7RoP"

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
NEW_WASM_POSITION="/home/jaypan/Work/peaq/peaq-network-node/new-target/wasm"


CHAIN_FOLDER="delete-evm-chain-folder"

rm -rf ${CHAIN_FOLDER}

${BINARY_POSITION} \
--parachain-id ${PARACHAIN_ID} \
--chain ${PARACHAIN_CONFIG} \
--port 50334 --rpc-port 9937 --base-path ${CHAIN_FOLDER} \
--unsafe-rpc-external --rpc-cors=all --rpc-methods=Unsafe \
--ethapi=debug,trace,txpool --wasm-runtime-overrides ${NEW_WASM_POSITION} --execution Wasm \
--bootnodes ${PARACHAIN_BOOTNODE} \
--rpc-max-response-size 1024 \
-- \
--execution wasm --chain ${RELAYCHAIN_CONFIG} \
--port 50345 \
--rpc-port 20055 \
--unsafe-rpc-external --rpc-cors=all
