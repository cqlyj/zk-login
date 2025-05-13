// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Groth16Verifier} from "src/verifier.sol";

contract DeployVerifier is Script {
    function run() external {
        vm.startBroadcast();
        address verifier = address(new Groth16Verifier());
        vm.stopBroadcast();

        console.log("Verifier deployed to: ", verifier);
    }
}
