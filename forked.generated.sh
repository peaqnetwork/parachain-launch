#!/bin/bash

PWD=`pwd`
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v06042023"
NOW_PARACHAIN_FILE_NAME="dev-2000.json"
RPC_ENDPOINT="https://rpcpc1-qa.agung.peaq.network"
DISABLE_FORK_SUFFEX="true"
ROCOCO_CONFIG_FILE="yoyo/rococo-local.json"
FORKED_CONFIG_FILE="config.parachain.agung.forked.yml"

# FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/krest-v31052023"
# NOW_PARACHAIN_FILE_NAME="krest-3000.json"

alias docker-compose="docker compose"
(cd yoyo; docker compose down -v)
rm -rf yoyo
(./bin/parachain-launch generate --config="${FORKED_CONFIG_FILE}" --output=yoyo)


# Copy file to the fork position
cp yoyo/$NOW_PARACHAIN_FILE_NAME $FORK_FOLDER/parachain.plaintext.config

# Run the fork
( \
 cd ~/Work/peaq/fork-test/fork-off-substrate; \
 env ALICE=1 \
 SOURCE_FOLDER=${FORK_FOLDER} \
 RPC_ENDPOINT=${RPC_ENDPOINT}\
 DISABLE_FORK_SUFFEX=${DISABLE_FORK_SUFFEX} \
 sh runtime.upgrade.test.sh; \
)

# Copy the forked file to the parachain-launch folder
pwd
cp $FORK_FOLDER/output/fork.json yoyo/$NOW_PARACHAIN_FILE_NAME

new_genesis_code=$(cat $FORK_FOLDER/output/fork.json.genesis)
# Replace the rococo's parchain genesis file
sed -i "s/\"genesis_head\": \".*\"/\"genesis_head\": \"$new_genesis_code\"/" ${ROCOCO_CONFIG_FILE}.original.json

# [TODO] Need to change
docker run --rm -v "${PWD}/${ROCOCO_CONFIG_FILE}.original.json":/rococo-local.json parity/polkadot:v0.9.42 build-spec --raw --chain=/rococo-local.json --disable-default-bootnode > ${ROCOCO_CONFIG_FILE}
