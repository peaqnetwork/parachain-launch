# parachain-launch

- [Introduction](#introduction)
- [Options](#options)
- [Preparation](#preparation)
- [Local Usage](#local-usage)
- [Start relaychain and parachain](#start-relaychain-and-parachain)
- [Additional Docker Commands](#additional-docker-commands)

# Introduction

parachain-launch is a script that generates a docker compose file allowing you to launch a testnet of multiple blockchain nodes.

# Options

The following options are supported by the generate script.

| Option        | Description                |Required            | Default      |
| ------------- |----------------------------|:------------------:|--------------|
| --config      | Path to config file.       | No                 | ./config.yml |
| --output      | Path to output dir.        | No                 | ./output     |
| --yes         | Overwrite generated files? | No                 | false        |

# Preparation

1. Download the [peaq-network-node](https://github.com/peaqnetwork/peaq-network-node)
2. Checkout to the `parachain_dev` branch in the peaq-network-node
3. Follow the [peaq-node-builder](https://github.com/peaqnetwork/peaq-node-builder) to build the peaq-node's binary
4. Build the docker images on the peaq-network-node folder.
```sh
cd ../peaq-network-node
docker build -f scripts/Dockerfile.parachain-launch -t peaq_para_node .
```

# Local Usage

1. Install dependency:

```sh
yarn install
```

2. Build project

```sh
yarn build
```

3. Use the `config.yml` file and edit as necessary.

4. Run the service from within the local directory:

```sh
./bin/parachain-launch generate --config=/path/to/config.yml [--yes] [--output=/path/to/output]
```

```sh
./bin/parachain-launch generate --config=config.yml --output=yoyo
```

This will generate the docker files a folder called `output` in your current working directory or in the directory provided to the `--output` option.

# Start relaychain and parachain

To start the nodes, navigate to the output folder that you generated the scripts in and build the docker container:

```sh
cd ./output # OR custom output directory

docker compose up -d --build
```

NOTE:

1. If you regenerate the output directory, you will need to rebuild the docker images.
2. Please use Polkadot/apps to connect the relay/parachain chain.

# Additional Docker Commands

List all of the containers:

```sh
docker ps -a
```

Track container logs:

```sh
docker logs -f [container_id/container_name]
```

Stop all of the containers:

```sh
docker compose stop
```

Remove all of the containers:

```sh
docker compose rm
```

Remove all of the containers and volumes (This will wipe any existing chain data):

```sh
docker compose down -v
```

## How to run the forked chain
1. Use `git submodule update --init --recursive` to download the fork-off-substrate
2. Go to the fork-off-substrate to install the library by `cd fork-off-substrate; npm install`
3. Setup all parameter needed in `forked.generated.sh`
4. Copy the peaq-node bianry to your FORK_FOLDER
If your want to forked the parachain which ran the runtime upgraded already, please remember to use the correct binary
and docker image which are the same as the runtime upgrade.
For example, our Krest network's runtime ugprade version is based on the krest-v0.0.3, then your binary/docker image
should be also based on the krest-v0.0.3
5. Execute the scripts `sh forked.generated.sh`, it'll launch the forked parchain automatically
However, please double-check the log carefully
```
FORKED_CONFIG_FILE="config.parachain.agung.forked.yml" \
RPC_ENDPOINT="https://rpcpc1-qa.agung.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/peaq-dev-v06042023" \
sh -e -x forked.generated.sh

FORKED_CONFIG_FILE="config.parachain.krest.forked.yml" \
RPC_ENDPOINT="https://erpc-krest.peaq.network" \
DOCKER_COMPOSE_FOLDER="yoyo" \
FORK_FOLDER="/home/jaypan/Work/peaq/fork-test/fork-binary/krest-v0.0.3" \
sh -e -x forked.generated.sh
```
