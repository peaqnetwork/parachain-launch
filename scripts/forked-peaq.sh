FORKED_CONFIG_FILE="scripts/config.parachain.peaq.forked.v0.0.110.yml" \
RPC_ENDPOINT="wss://mpfn1.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
RELAY_CHAIN_CONFIG_FILE="rococo-local.json" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-v0.0.110" \
KEEP_COLLATOR="false" \
KEEP_ASSET="true" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh

# NO_IGNORE_SIZE=1000 \
# In the docker enviroment, we should use westend-local.json to reduce the session length
