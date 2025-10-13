.PHONY: ft test coverage

ft:
	forge coverage 

# Main command - runs lint then build
fb:  build # add linting

# Individual steps

build:
	forge build

