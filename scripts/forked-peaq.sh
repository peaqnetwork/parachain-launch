FORKED_CONFIG_FILE="scripts/config.parachain.peaq.forked.v0.0.1.yml" \
RPC_ENDPOINT="https://erpc-mpfn1.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-v0.0.1" \
KEEP_COLLATOR="false" \
KEEP_PARACHAIN="true" \
sh -e -x forked.generated.sh
