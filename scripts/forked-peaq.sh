FORKED_CONFIG_FILE="scripts/config.parachain.peaq.forked.v0.0.7.yml" \
RPC_ENDPOINT="https://erpc-mpfn1.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-v0.0.7" \
KEEP_COLLATOR="false" \
KEEP_ASSET="false" \
KEEP_PARACHAIN="false" \
sh -e -x forked.generated.sh
