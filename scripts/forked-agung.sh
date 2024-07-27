FORKED_CONFIG_FILE="scripts/config.parachain.peaq-dev.forked.v0.0.18.yml" \
RPC_ENDPOINT="https://rpcpc1-qa.agung.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v0.0.18" \
KEEP_COLLATOR="false" \
KEEP_ASSET="true" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh
