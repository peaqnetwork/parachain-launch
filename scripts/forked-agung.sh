FORKED_CONFIG_FILE="scripts/config.parachain.peaq-dev.forked.v0.0.102.yml" \
RPC_ENDPOINT="https://wss-async.agung.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
RELAY_CHAIN_CONFIG_FILE="rococo-local.json" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v0.0.102" \
KEEP_COLLATOR="false" \
KEEP_ASSET="true" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh

# In the docker enviroment, we should use westend-local.json to reduce the session length
