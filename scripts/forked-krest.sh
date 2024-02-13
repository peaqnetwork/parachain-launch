FORKED_CONFIG_FILE="scripts/config.parachain.krest.forked.v0.0.5.yml" \
RPC_ENDPOINT="https://erpc-krest.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/krest-v0.0.5" \
KEEP_COLLATOR="false" \
KEEP_PARACHAIN="true" \
sh -e -x forked.generated.sh
