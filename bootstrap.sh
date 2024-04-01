# Build barretenberg cpp
# TODO: only build honk_gen - not everything
echo "Downloading srs..."
(cd ./barretenberg/barretenberg/cpp/srs_db && ./download_ignition.sh 3)
(cd ./barretenberg/barretenberg/cpp && cmake --preset clang16)
(cd ./barretenberg/barretenberg/cpp && cmake --preset clang16)
(cd ./barretenberg/barretenberg/cpp && cmake --build --preset clang16 --target honk_solidity_proof_gen)


