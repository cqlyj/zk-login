// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Login} from "src/Login.sol";
import {Vm} from "forge-std/Vm.sol";

contract DeployLogin is Script {
    function run() external {
        address verifierAddress = Vm(address(vm)).getDeployment(
            "Groth16Verifier",
            uint64(block.chainid)
        );

        vm.startBroadcast();
        Login login = new Login(verifierAddress);
        vm.stopBroadcast();
        console.log("Login deployed to: ", address(login));
    }
}
