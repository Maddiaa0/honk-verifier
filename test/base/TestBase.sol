pragma solidity >=0.8.21;

import {Test} from "forge-std/Test.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract TestBase is Test {
    using Strings for uint256;

    function readProofData(string memory path) internal view returns (bytes memory) {
        // format [4 byte length][data]
        // Reads the raw bytes
        bytes memory rawBytes = vm.readFileBinary(path);

        // Extract the [data], contains inputs and proof
        bytes memory proofData = new bytes(rawBytes.length - 4); //
        assembly {
            let length := shr(224, mload(add(rawBytes, 0x20)))

            let wLoc := add(proofData, 0x20)
            let rLoc := add(rawBytes, 0x24)
            let end := add(rLoc, length)

            for {} lt(rLoc, end) {
                wLoc := add(wLoc, 0x20)
                rLoc := add(rLoc, 0x20)
            } { mstore(wLoc, mload(rLoc)) }
        }
        return proofData;
    }


    function splitProofHonk(bytes memory _proofData, uint256 _numberOfPublicInputs)
        internal
        view
        returns (bytes32[] memory publicInputs, bytes memory proof)
    {
        publicInputs = new bytes32[](_numberOfPublicInputs);
        for (uint256 i = 0; i < _numberOfPublicInputs; i++) {
            // The proofs spit out by barretenberg have the public inputs at the beginning
            publicInputs[i] = readWordByIndex(_proofData, i + 3);
        }

        proof = new bytes(_proofData.length - (_numberOfPublicInputs * 0x20));
        uint256 len = proof.length;

        // Copy first 3 words from proofData to proof
        assembly {
            mstore(add(proof, 0x20), mload(add(_proofData, 0x20)))
            mstore(add(proof, 0x40), mload(add(_proofData, 0x40)))
            mstore(add(proof, 0x60), mload(add(_proofData, 0x60)))
        }

        // Copy the rest of the proof
        assembly {
            pop(
                staticcall(
                    gas(),
                    0x4,
                    add(
                        _proofData,
                        add(
                            0x20,
                            mul(
                                0x20,
                                add(_numberOfPublicInputs, 3) // Then skip public inputs & 3 words already added
                            )
                        )
                    ),
                    len,
                    add(
                        proof,
                        add(0x20, 0x60) // skip the first 3 words we added above
                    ),
                    len
                )
            )
        }
    }

    function readWordByIndex(bytes memory _data, uint256 index) internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(_data, add(0x20, mul(0x20, index))))
        }
    }

}
