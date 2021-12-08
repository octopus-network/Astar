# Local Testnet

## Requirements
* `timeout` - native package on Ubuntu, on macOS try ```brew install coreutils```
* `jq` - https://stedolan.github.io/jq/download/
* sponge - Is available in the moreutils package. On Mac see https://formulae.brew.sh/formula/moreutils. On Linux:

  ```bash
  apt install moreutils
  ```

* polkadot-launch

  ```bash
  yarn global remove polkadot-launch
  git clone https://github.com/octopus-network/polkadot-launch.git
  cd polkadot-launch
  git checkout 92751e9ff833e89a100d553ae4d9b6452e8aa82f 
  yarn install
  yarn build
  yarn global add file:$(pwd)
  ```

## Setup

### Polkadot

```bash
git clone -n https://github.com/paritytech/polkadot.git
git checkout v0.9.13-rc1
./scripts/init.sh
cargo build --release
```

### Configure testnet

Create an `.env` file with variables that point to the binaries for polkadot

Example:
```
POLKADOT_BIN=/path/to/polkadot/target/release/polkadot
```

## Launch the testnet

Run the following script
```bash
cargo build --release
cd test
. scripts/start-services.sh
```

Wait until the "System has been initialized" message

Go to polkadot-js and wait until the parachain has started producing blocks:
https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9988#/explorer

You can see the relay chain by connecting to https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer

Confirm the block number is > 2

### Troubleshooting

The `start-services.sh` script writes the following logs:

- Parachain nodes: {9944,9955}.log
- Relay services: {alice,bob,charlie,dave}.log
