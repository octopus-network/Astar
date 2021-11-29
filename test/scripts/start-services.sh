#!/usr/bin/env bash
set -eu

root_dir="$(realpath ..)"
parachain_dir="$root_dir"

output_dir=/tmp/astar-collator

start_polkadot_launch()
{
    if [[ -z "${POLKADOT_BIN+x}" ]]; then
        echo "Please specify the path to the polkadot binary. Variable POLKADOT_BIN is unset."
    fi

    local parachain_bin="$parachain_dir/target/release/astar-collator"

    echo "Building parachain node"
    cd ..
    cargo build --release
    cd test

    jq \
        --arg polkadot "$(realpath $POLKADOT_BIN)" \
        --arg bin "$parachain_bin" \
        ' .relaychain.bin = $polkadot
        | .parachains[0].bin = $bin
        ' \
        config/shiden-launch-config.json \
        > "$output_dir/launch-config.json"

     cat "$output_dir/launch-config.json"
    polkadot-launch "$output_dir/launch-config.json" &
    scripts/wait-for-it.sh -t 120 localhost:11144
}

cleanup() {
    trap - SIGTERM
    kill -- -"$(ps -o pgid:1= $$)"
}

trap cleanup SIGINT SIGTERM EXIT

if [[ -f ".env" ]]; then
    export $(<.env)
fi

rm -rf "$output_dir"
mkdir "$output_dir"

#start_geth
#deploy_contracts
start_polkadot_launch

echo "Waiting for consensus between polkadot and parachain"
sleep 60
#configure_contracts
#start_relayer

echo "Process Tree:"
pstree -T $$

echo "Testnet has been initialized"
wait
