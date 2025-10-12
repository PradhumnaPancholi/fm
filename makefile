test:
	forge test -vvv

fmt:
	forge fmt

build:
	forge build

check: fmt build test
	@echo "✅ Done"
