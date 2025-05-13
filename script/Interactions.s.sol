// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {Login} from "src/Login.sol";
import {Vm} from "forge-std/Vm.sol";

contract Register is Script {
    uint256 walletAddress = 1390849295786071768276380950238675083608645509734;
    uint256 salt = 111;
    uint256 credential_hash =
        7194512057979358495591067604050974528599555243308123095846893334515996211420;
    uint256 nonce = 0;
    uint256 result_hash =
        12691489434642607772344459505540913560453102523020028123184504009211690115528;

    uint[2] public _pA;
    uint[2][2] public _pB;
    uint[2] public _pC;

    function run() external {
        address loginAddress = Vm(address(vm)).getDeployment(
            "Login",
            uint64(block.chainid)
        );
        Login login = Login(loginAddress);

        _pA = [
            uint256(
                0x26359314f80e95d0217e2dc24b0fb88ecf4f230106796fa174a421ba4fd0daba
            ),
            uint256(
                0x049a5931335e66a246f1c7748ddeee93b0d665e2395c84729017fcd9d873cad1
            )
        ];

        _pB = [
            [
                uint256(
                    0x0ca2825fab56b074d4333c2e6a0f4fdad71c362bb59731ec3975c45e09ada87f
                ),
                uint256(
                    0x1ea2fd8b3e4ab8ff508486ea7aab5a6dd4f6585898f21ef6ce9c34b2da602e68
                )
            ],
            [
                uint256(
                    0x11c2655c74d43f8204e8700bd6323e090703c4f0ef4f44c25340789c8c87b5a4
                ),
                uint256(
                    0x1b6bce59f45987444f9b9bef29d94b8b51da8eb92f8a1f190cfede8e162eb0e1
                )
            ]
        ];

        _pC = [
            uint256(
                0x071846202798e11f2be91e98be4972c3e45a07e268828ee57cc7870cc4ecf692
            ),
            uint256(
                0x114779ea2fa1c6923dbb1b5be9e6ba0c486041b1a717e310bf7d3084744f27d6
            )
        ];

        vm.startBroadcast();
        login.register(
            _pA,
            _pB,
            _pC,
            walletAddress,
            salt,
            credential_hash,
            nonce,
            result_hash
        );
        vm.stopBroadcast();

        console.log("Register successfully");
    }
}
