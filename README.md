<img align="right" width="150" height="150" top="100" src="./public/honk.webp">

## EVM Honk Verifier

**An EVM verifier for the HONK (sumcheck + shplemini) proving system.**

This repo consists of:

- A differential fuzzer against a cpp implementation (found in barretenberg)
- A verifier for an ECDSA circuit

## Upcoming

- Optimized assembly implementation

## Building
1. **C++**
On ubuntu make sure you have a cpp toolchain installed -> (or most up to date, i just use whatever works with  clang16)
```
sudo apt-get install cmake clang clang-format ninja-build libstdc++-12-dev 
```
We will be building with clang16 - so make sure you have that compiler :)

2. **Foundry**
See installation instructions here: https://book.getfoundry.sh/


## Usage

### Build

```shell
$ ./bootstrap.sh # This will download the SRS and build the C++
$ forge build # Build the contracts
```

### Test

```shell
$ forge test --no-match-contract TestBaseHonk
```
