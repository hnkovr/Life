.PHONY: help link hardlink unlink test test-internal test-external shellcheck bats yq-check dotenv-lint direnv-allow env healthcheck tools-install

# Repo paths
REPO_ROOT := $(CURDIR)
BIN_DIR := $(HOME)/bin

# Link names in home; override by passing e.g. `make link HOME_LIFE=~/.mylife`
HOME_LIFE := $(HOME)/life
HOME_LIFE_DIR := $(HOME)/.life
HOME_MAKE := $(HOME)/Makefile.life
HOME_JUST := $(HOME)/Justfile.life

# Bash utils helper
BASH_UTILS := scripts/lib/bash-utils.sh
SOURCE_UTILS := set -euo pipefail; source $(BASH_UTILS);

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
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_required bats "bats not installed; needed for '\''make test-external'\''. Install with '\''make tools-install'\'' or via brew install bats-core" \
	  bash -c "echo \"> bats detected\"; bats scripts/tests"'

bashly-check: ## Show bashly version if installed
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_required bashly "bashly not installed; required if you want to generate CLIs" \
	  bashly --version'

tools-install: ## Install bash tooling (macOS Homebrew / Linux apt)
	@bash scripts/tools/install-bash-tools.sh

shellcheck: ## Run shellcheck on repo scripts if available
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_optional shellcheck "shellcheck not installed; skipping" \
	  bash -c "echo \"> shellcheck\"; shellcheck -x scripts/*.sh || true"'

yq-check: ## Show yq version and sample check if installed
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_optional yq "yq not installed; skipping" \
	  bash -c "echo \"> yq version\"; yq --version"'

dotenv-lint: ## Lint .env if dotenv-linter is installed
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_if_file_and_cmd .env dotenv-linter "dotenv-linter not installed or .env missing; skipping" \
	  dotenv-linter .env'

direnv-allow: ## Allow direnv in this directory if installed
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_optional direnv "direnv not installed; skipping" \
	  bash -c "direnv allow || true"'

env: ## Show env loaded with shdotenv if installed
	@bash -c '$(SOURCE_UTILS) \
	  if [ ! -f .env ] && [ -x ./scripts/.env-generator.sh ]; then \
	    echo "> generating .env"; ./scripts/.env-generator.sh; \
	  fi; \
	  bu::run_optional shdotenv "shdotenv not installed; skipping" \
	  bash -c "shdotenv -f .env -q -e || true"'

env-generate: ## Generate/update .env from .env.example (interactive for *_PASSWORD)
	@chmod +x ./scripts/.env-generator.sh || true
	@./scripts/.env-generator.sh

healthcheck: ## Run repo healthcheck script (if present)
	@bash -c '$(SOURCE_UTILS) \
	  bu::run_script scripts/healthcheck.sh'
