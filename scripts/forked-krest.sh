FORKED_CONFIG_FILE="scripts/config.parachain.krest.forked.v0.0.7.yml" \
RPC_ENDPOINT="https://erpc-krest.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/krest-v0.0.7" \
KEEP_COLLATOR="false" \
KEEP_ASSETS="false" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh
