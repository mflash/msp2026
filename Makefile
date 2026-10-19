# ==============================================================================
# Makefile: Local Markdown to HTML static site builder with Pandoc
# ==============================================================================

# Executables
PANDOC      := pandoc
PYTHON      := python3

# Directories
SRC_DIR     := docs
DIST_DIR    := dist
ASSETS_DIR  := img

# Assets & Config
CSS_FILE    := style.css
PANDOC_FLAGS := --standalone \
                --css=$(CSS_FILE) \
                --syntax-highlighting=pygments \
                --to=html5

# Source files and compilation targets
SOURCES     := $(wildcard $(SRC_DIR)/*.md)
TARGETS     := $(patsubst $(SRC_DIR)/%.md,$(DIST_DIR)/%.html,$(SOURCES))

.PHONY: all build clean serve help

# Default target
all: build

## build: Compile all markdown files and copy assets into dist/
build: $(TARGETS) copy-assets $(DIST_DIR)/.nojekyll

# Pattern rule: compile .md to .html (rebuilds if source or stylesheet changes)
$(DIST_DIR)/%.html: $(SRC_DIR)/%.md $(CSS_FILE) | $(DIST_DIR)
	@title=$$(head -n 5 "$<" | grep -m1 '^# ' | sed 's/^# //' || echo ""); \
	if [ -n "$$title" ]; then \
		$(PANDOC) "$<" $(PANDOC_FLAGS) --metadata pagetitle="$$title" -o "$@"; \
	else \
		$(PANDOC) "$<" $(PANDOC_FLAGS) -o "$@"; \
	fi
	@echo "Rendered: $< -> $@"

# Ensure output directory exists
$(DIST_DIR):
	mkdir -p $(DIST_DIR)

# Copy stylesheet, optional assets directory, and .nojekyll
copy-assets: | $(DIST_DIR)
	@cp $(CSS_FILE) $(DIST_DIR)/
	@if [ -d "$(ASSETS_DIR)" ]; then \
		cp -r $(ASSETS_DIR) $(DIST_DIR)/; \
		echo "Copied assets directory"; \
	fi
	@for html in $(wildcard $(SRC_DIR)/*.html); do \
		cp "$$html" $(DIST_DIR)/ && echo "Copied $$html -> $(DIST_DIR)/"; \
	done

$(DIST_DIR)/.nojekyll: | $(DIST_DIR)
	@touch $(DIST_DIR)/.nojekyll

## clean: Remove compiled artifacts
clean:
	rm -rf $(DIST_DIR)
	@echo "Clean complete."

## serve: Start a local HTTP server on port 8000 for preview
serve: build
	@echo "Serving at http://localhost:8000 (Ctrl+C to stop)..."
	@cd $(DIST_DIR) && $(PYTHON) -m http.server 8000

## help: Show available Makefile targets
help:
	@echo "Available commands:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':'
