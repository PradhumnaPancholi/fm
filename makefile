.PHONY: ft test coverage

ft:
	forge coverage 

# Sepolia Deploy
fdl:
	forge script ./scripts/DeploySERC20.s.sol:SERC20Script --rpc-url http:localhost:8545 --account dummy1 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast -- --vvvv
# Main command - runs lint then build
fb:  build # add linting

# Individual steps

build:
	forge build

