FORKED_CONFIG_FILE="scripts/config.parachain.peaq-dev.forked.moonbeam.v0.0.14.yml" \
RPC_ENDPOINT="https://moonbeam.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v0.0.14.moonbeam" \
KEEP_COLLATOR="false" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh
