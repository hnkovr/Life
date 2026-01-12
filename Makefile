.PHONY: help link hardlink unlink test test-internal test-external shellcheck bats yq-check dotenv-lint direnv-allow env healthcheck

# Repo paths
REPO_ROOT := $(CURDIR)
BIN_DIR := $(HOME)/bin

# Link names in home; override by passing e.g. `make link HOME_LIFE=~/.mylife`
HOME_LIFE := $(HOME)/life
HOME_LIFE_DIR := $(HOME)/.life
HOME_MAKE := $(HOME)/Makefile.life
HOME_JUST := $(HOME)/Justfile.life

# Tool discovery helpers
has = $(shell command -v $(1) >/dev/null 2>&1 && echo 1 || echo 0)

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"}; /^[a-zA-Z0-9_.-]+:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

link: ## Create convenient symlinks in HOME (~/.life, ~/life, Makefile.life, Justfile.life)
	@chmod +x "$(REPO_ROOT)/scripts/life.sh" || true
	@bash scripts/life.sh links create --mode symlink --force \
	  --home-life "$(HOME_LIFE)" \
	  --home-life-dir "$(HOME_LIFE_DIR)" \
	  --home-make "$(HOME_MAKE)" \
	  --home-just "$(HOME_JUST)"
	@mkdir -p "$(BIN_DIR)" && ln -sf "$(REPO_ROOT)/scripts/life.sh" "$(BIN_DIR)/life" && chmod +x "$(REPO_ROOT)/scripts/life.sh" || true
	@printf "Linked: %s %s %s %s and %s\n" "$(HOME_LIFE_DIR)" "$(HOME_LIFE)" "$(HOME_MAKE)" "$(HOME_JUST)" "$(BIN_DIR)/life"

hardlink: ## Create hardlinks in HOME (files only)
	@bash scripts/life.sh links create --mode hardlink --force \
	  --home-life "$(HOME_LIFE)" \
	  --home-make "$(HOME_MAKE)" \
	  --home-just "$(HOME_JUST)"
	@printf "Hardlinked files: %s %s %s\n" "$(HOME_LIFE)" "$(HOME_MAKE)" "$(HOME_JUST)"

unlink: ## Remove created links from HOME
	@bash scripts/life.sh links remove \
	  --home-life "$(HOME_LIFE)" \
	  --home-life-dir "$(HOME_LIFE_DIR)" \
	  --home-make "$(HOME_MAKE)" \
	  --home-just "$(HOME_JUST)"

test: test-internal test-external ## Run all tests (internal + external)

test-internal: ## Run in-file self-tests (no external deps)
	@bash -c 'source scripts/life.sh >/dev/null 2>&1; life::selftest'

test-external: ## Run Bats tests if available
	@if [ "$(call has,bats)" = 1 ]; then \
	  echo "> bats detected"; bats scripts/tests; \
	else \
	  echo "bats not installed; skipping external tests"; \
	fi

bashly-check: ## Show bashly version if installed
	@if [ "$(call has,bashly)" = 1 ]; then \
	  bashly --version; \
	else \
	  echo "bashly not installed; skipping"; \
	fi

shellcheck: ## Run shellcheck on repo scripts if available
	@if [ "$(call has,shellcheck)" = 1 ]; then \
	  echo "> shellcheck"; shellcheck -x scripts/*.sh || true; \
	else \
	  echo "shellcheck not installed; skipping"; \
	fi

yq-check: ## Show yq version and sample check if installed
	@if [ "$(call has,yq)" = 1 ]; then \
	  echo "> yq version"; yq --version; \
	else \
	  echo "yq not installed; skipping"; \
	fi

dotenv-lint: ## Lint .env if dotenv-linter is installed
	@if [ -f .env ] && [ "$(call has,dotenv-linter)" = 1 ]; then \
	  dotenv-linter .env; \
	else \
	  echo "dotenv-linter not installed or .env missing; skipping"; \
	fi

direnv-allow: ## Allow direnv in this directory if installed
	@if [ "$(call has,direnv)" = 1 ]; then \
	  direnv allow || true; \
	else \
	  echo "direnv not installed; skipping"; \
	fi

env: ## Show env loaded with shdotenv if installed
	@if [ ! -f .env ] && [ -x ./.env-generator ]; then \
	  echo "> generating .env"; ./.env-generator; \
	fi; \
	if [ "$(call has,shdotenv)" = 1 ]; then \
	  shdotenv -f .env -q -e || true; \
	else \
	  echo "shdotenv not installed; skipping"; \
	fi

env-generate: ## Generate/update .env from .env.example (interactive for *_PASSWORD)
	@chmod +x ./.env-generator || true
	@./.env-generator

healthcheck: ## Run repo healthcheck script (if present)
	@if [ -x scripts/healthcheck.sh ] || [ -f scripts/healthcheck.sh ]; then \
	  bash scripts/healthcheck.sh || true; \
	else \
	  echo "scripts/healthcheck.sh not present"; \
	fi
