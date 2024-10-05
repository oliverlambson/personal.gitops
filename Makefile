.PHONY: secrets
secrets:
	find . -name "*.op" | xargs -I FILE sh -c 'echo "Processing $$1"; op inject -f -i "$$1" -o "$${1%.op}"' _ FILE
