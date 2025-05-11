compile:
	@circom zk/circuits/pinVerification.circom --r1cs --wasm --sym -o zk/outputs/

setup-key:
	@wget https://storage.googleapis.com/zkevm/ptau/powersOfTau28_hez_final_10.ptau -O zk/outputs/pot10.ptau