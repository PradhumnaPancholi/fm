
DOC_TITLE      := "fm - Modular and Secure Solidity Snippets"
DOC_HOMEPAGE   := "https://github.com/pradhumnapancholi/fm"
DOC_GITHUB     := "pradhumnapancholi/fm"
DOC_BRANCH     := "main"
DOC_OUTPUT     := "docs"

.PHONY: ft test coverage
ft:
	forge coverage 

.PHONY: doc
doc:
	@echo "Building contracts..."
	@echo "Generating documentation"
	@set -e; \
	forge build; \
	forge doc --out $(DOC_OUTPUT); \
	sed -i 's|<title>.*</title>|<title>$(DOC_TITLE)</title>|' $(DOC_OUTPUT)/book/index.html; \
	echo "Docs are ready!"

# Main command - runs lint then build
fb:  build # add linting

# Individual steps

build:
	forge build

