bootstrap:
	./scripts/bootstrap.sh

mint-bootstrap:
	MINT_PATH=./mint/lib MINT_LINK_PATH=./mint/bin mint bootstrap

carthage-bootstrap:
	mint run carthage bootstrap --use-xcframeworks --platform iOS