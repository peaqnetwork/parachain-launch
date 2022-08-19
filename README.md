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

2. Build the docker images
```sh
docker build -f scripts/peaq.Dockerfile -t peaqtest .
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

This will generate the docker files a folder called `output` in your current working directory or in the directory provided to the `--output` option.

# Start relaychain and parachain

To start the nodes, navigate to the output folder that you generated the scripts in and build the docker container:

```sh
cd ./output # OR custom output directory

docker-compose up -d --build
```

NOTE:

1. If you regenerate the output directory then you will need to rebuild the docker images.
2. Please polkadot/apps to connect the relay/parachain chain.

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
docker-compose stop
```

Remove all of the containers:

```sh
docker-compose rm
```

Remove all of the containers and volumes (This will wipe any existing chain data):

```sh
docker-compose down -v
```
