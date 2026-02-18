.PHONY: build clean install

# Default target: Build the app
build:
	bash build.sh

# Clean up build artifacts and downloads
clean:
	rm -rf Codex.app Codex_Intel.app Codex.dmg

# Install the app to /Applications
install:
	@if [ -d "Codex.app" ]; then \
		echo "Removing old version from /Applications..."; \
		rm -rf /Applications/Codex.app; \
		echo "Moving Codex.app to /Applications..."; \
		mv Codex.app /Applications/; \
		echo "Done."; \
	else \
		echo "Codex.app not found. Please run 'make' first."; \
		exit 1; \
	fi
