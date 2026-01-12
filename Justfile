# Variables
set shell := ["bash", "-euo", "pipefail", "-c"]

REPO_ROOT := `pwd`
HOME_LIFE := env_var("HOME") + "/life"
HOME_LIFE_DIR := env_var("HOME") + "/.life"
HOME_MAKE := env_var("HOME") + "/Makefile.life"
HOME_JUST := env_var("HOME") + "/Justfile.life"
BIN_DIR := env_var("HOME") + "/bin"

default: help

help:
  @awk 'BEGIN {FS = ":.*##"}; /^[a-zA-Z0-9_.-]+:.*?##/ { printf "\033[36m%-22s\033[0m %s\n", $$1, $$2 }' Makefile

link: ## Create home symlinks and bin helper
  bash scripts/life.sh links create --mode symlink --force \
    --home-life "{{HOME_LIFE}}" \
    --home-life-dir "{{HOME_LIFE_DIR}}" \
    --home-make "{{HOME_MAKE}}" \
    --home-just "{{HOME_JUST}}"
  mkdir -p "{{BIN_DIR}}" && ln -sf "{{REPO_ROOT}}/scripts/life.sh" "{{BIN_DIR}}/life" && chmod +x "{{BIN_DIR}}/life" || true
  @echo "Linked home shortcuts and bin/life"

hardlink: ## Create hardlinks in HOME (files only)
  bash scripts/life.sh links create --mode hardlink --force \
    --home-life "{{HOME_LIFE}}" \
    --home-make "{{HOME_MAKE}}" \
    --home-just "{{HOME_JUST}}"

unlink: ## Remove created links from HOME
  bash scripts/life.sh links remove \
    --home-life "{{HOME_LIFE}}" \
    --home-life-dir "{{HOME_LIFE_DIR}}" \
    --home-make "{{HOME_MAKE}}" \
    --home-just "{{HOME_JUST}}"

test: test-internal test-external ## Run all tests

test-internal: ## Run in-file self-tests
  bash -lc 'source scripts/life.sh >/dev/null 2>&1; life::selftest'

test-external: ## Run Bats tests if installed
  if command -v bats >/dev/null 2>&1; then echo "> bats detected"; bats scripts/tests; else echo "bats not installed; skipping"; fi

shellcheck: ## Run shellcheck on repo scripts if available
  if command -v shellcheck >/dev/null 2>&1; then echo "> shellcheck"; shellcheck -x scripts/*.sh || true; else echo "shellcheck not installed; skipping"; fi

yq-check: ## Show yq version and sample check
  if command -v yq >/dev/null 2>&1; then yq --version; else echo "yq not installed; skipping"; fi

dotenv-lint: ## Lint .env with dotenv-linter if available
  if [ -f .env ] && command -v dotenv-linter >/dev/null 2>&1; then dotenv-linter .env; else echo "dotenv-linter not installed or .env missing; skipping"; fi

direnv-allow: ## Allow direnv for this directory
  if command -v direnv >/dev/null 2>&1; then direnv allow || true; else echo "direnv not installed; skipping"; fi

env: ## Print env via shdotenv if available
  if [ ! -f .env ] && [ -x ./.env-generator ]; then echo "> generating .env"; ./.env-generator; fi
  if command -v shdotenv >/dev/null 2>&1; then shdotenv -f .env -q -e || true; else echo "shdotenv not installed; skipping"; fi

healthcheck: ## Run repo healthcheck script
  if [ -x scripts/healthcheck.sh ] || [ -f scripts/healthcheck.sh ]; then bash scripts/healthcheck.sh || true; else echo "scripts/healthcheck.sh not present"; fi

env-generate: ## Generate/update .env from .env.example (interactive for *_PASSWORD)
  chmod +x ./.env-generator || true
  ./.env-generator
