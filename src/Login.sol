// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IVerifier} from "./interfaces/IVerifier.sol";

contract Login {
    IVerifier public zkVerifier;
    mapping(uint256 wallet => uint256 credentialHash) public credentialHashes;
    mapping(uint256 wallet => mapping(uint256 nonce => bool usedOrNot))
        public usedNonces;

    error Login__InvalidProof();
    error Login__InvalidCredentials();
    error Login__NonceAlreadyUsed();

    event Registered(
        uint256 indexed wallet,
        uint256 credential_hash,
        uint256 nonce
    );
    event Logined(
        uint256 indexed wallet,
        uint256 credential_hash,
        uint256 nonce
    );

    constructor(address zkVerifierAddress) {
        zkVerifier = IVerifier(zkVerifierAddress);
    }

    function register(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint256 wallet,
        uint256 salt,
        uint256 credential_hash,
        uint256 nonce,
        uint256 result_hash
    ) external {
        // checks here, but for now just skip those
        // @TODO: add checks

        uint256[5] memory pubSignals;
        pubSignals[0] = wallet;
        pubSignals[1] = salt;
        pubSignals[2] = credential_hash;
        pubSignals[3] = nonce;
        pubSignals[4] = result_hash;

        if (!zkVerifier.verifyProof(_pA, _pB, _pC, pubSignals)) {
            revert Login__InvalidProof();
        }

        credentialHashes[wallet] = credential_hash;
        usedNonces[wallet][nonce] = true;

        emit Registered(wallet, credential_hash, nonce);
    }

    function login(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint256 wallet,
        uint256 salt,
        uint256 credential_hash,
        uint256 nonce,
        uint256 result_hash
    ) external {
        // TODO: add more checks

        if (credentialHashes[wallet] != credential_hash) {
            revert Login__InvalidCredentials();
        }

        if (usedNonces[wallet][nonce]) {
            revert Login__NonceAlreadyUsed();
        }

        uint256[5] memory pubSignals = [
            wallet,
            salt,
            credential_hash,
            nonce,
            result_hash
        ];

        if (!zkVerifier.verifyProof(_pA, _pB, _pC, pubSignals)) {
            revert Login__InvalidProof();
        }

        usedNonces[wallet][nonce] = true;

        emit Logined(wallet, credential_hash, nonce);
    }
}
