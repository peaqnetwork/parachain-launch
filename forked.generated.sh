#!/bin/sh

# Parachin chains configurataion files
FORKED_CONFIG_FILE=${FORKED_CONFIG_FILE:-"config.parachain.agung.forked.yml"}
RPC_ENDPOINT=${RPC_ENDPOINT:-"https://rpcpc1-qa.agung.peaq.network"}
DOCKER_COMPOSE_FOLDER=${DOCKER_COMPOSE_FOLDER:-"yoyo"}
FORK_FOLDER=${FORK_FOLDER:="path-not-exist"}
RELAY_CHAIN_CONFIG_FILE=${RELAY_CHAIN_CONFIG_FILE:-"rococo-local.json"}

extract_parachain_spec() {
  local input_file="$1"
  local base=""
  local id=""
  local found=false

  while IFS= read -r line; do
    if [ "$found" = false ] && echo "$line" | grep -q "base:"; then
      base=$(echo "$line" | awk -F ': ' '{print $2}' | sed 's/ *#.*//')
    elif [ "$found" = false ] && echo "$line" | grep -q "id:"; then
      id=$(echo "$line" | awk -F ': ' '{print $2}' | sed 's/ *#.*//')
      found=true
    fi
  done < "$input_file"

  if [ "$found" = true ] && [ -n "$base" ] && [ -n "$id" ]; then
    local json_data="$base-$id.json"
    echo "$json_data"
  else
    echo "Error: failed to extract 'base' and 'id' values"
    exit 1
  fi
}

real_path=$(realpath "$DOCKER_COMPOSE_FOLDER")
if [ "$real_path" = "/" ]; then
  echo "Please reset the DOCKER_COMPOSE_FOLDER, $DOCKER_COMPOSE_FOLDER, variable in the script"
  exit 1
fi

# Below variables are internal used, no need to change it
# These files are generated by the parachain-launch
# But below files are changed by the configuration
now_parachain_file_name=$(extract_parachain_spec "$FORKED_CONFIG_FILE")
host_relay_chain_config_file=${DOCKER_COMPOSE_FOLDER}/"${RELAY_CHAIN_CONFIG_FILE}"
polkadot_image=`cat ${FORKED_CONFIG_FILE} | grep image | grep polkadot | awk -F': ' '{print $2}' | awk '{print $1}'`
if command -p docker-compose >/dev/null 2>&1
then
  docker_compose_cmd="docker-compose"
else
  docker_compose_cmd="docker compose"
fi

# Stop the docker-compose and regenerate
(cd ${DOCKER_COMPOSE_FOLDER}; ${docker_compose_cmd} down -v) || true
rm -rf ${DOCKER_COMPOSE_FOLDER} || true
(./bin/parachain-launch generate --config="${FORKED_CONFIG_FILE}" --output=${DOCKER_COMPOSE_FOLDER})


# Copy file to the fork position
cp ${DOCKER_COMPOSE_FOLDER}/$now_parachain_file_name $FORK_FOLDER/parachain.plaintext.config

# Run the fork
( \
 cd fork-off-substrate; \
 env ALICE=1 \
 SOURCE_PATH=${FORK_FOLDER} \
 RPC_ENDPOINT=${RPC_ENDPOINT}\
 sh forked.generated.sh; \
)

# Copy the forked file to the parachain-launch folder
cp $FORK_FOLDER/output/fork.json ${DOCKER_COMPOSE_FOLDER}/$now_parachain_file_name

new_genesis_code=$(cat $FORK_FOLDER/output/fork.json.genesis)
# Replace the rococo's parchain genesis file
sed -i "0,/\"genesis_head\": \".*\"/s//\"genesis_head\": \"$new_genesis_code\"/" ${host_relay_chain_config_file}.original.json

PWD=`pwd`
docker run --rm -v "${PWD}/${host_relay_chain_config_file}.original.json":/${RELAY_CHAIN_CONFIG_FILE} ${polkadot_image} build-spec --raw --chain=/${RELAY_CHAIN_CONFIG_FILE} --disable-default-bootnode > ${host_relay_chain_config_file}

( \
 cd ${DOCKER_COMPOSE_FOLDER}; \
 ${docker_compose_cmd} up -d --build --remove-orphans; \
)
