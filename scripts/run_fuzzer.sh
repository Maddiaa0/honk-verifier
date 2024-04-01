#!/usr/bin/env bash
BB_BASE="barretenberg/barretenberg"

PLONK_FLAVOUR=${1:-"ultra"}
CIRCUIT_FLAVOUR=${2:-"blake"}
INPUTS=${3:-"1,2,3,4"}

BIN="$BB_BASE/cpp/build/bin/solidity_proof_gen"

INPUTS="$( sed 's/\\n//g' <<<"$INPUTS" )"

SRS_PATH="$BB_BASE/cpp/srs_db/ignition"

# If the plonk flavour is honk, then run the honk generator
if [ "$PLONK_FLAVOUR" == "honk" ]; then
    BIN="$BB_BASE/cpp/build/bin/honk_solidity_proof_gen"
fi

$BIN $PLONK_FLAVOUR $CIRCUIT_FLAVOUR $SRS_PATH $INPUTS