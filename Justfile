# Variables
set shell := ["bash", "-euo", "pipefail", "-c"]

# Bash utils helper - sourced in recipes that use bu:: functions
BASH_UTILS := justfile_directory() + "/scripts/lib/bash-utils.sh"

# Bash header for recipes using bu:: functions
# Note: Justfile variable expansion {{BASH_HEADER}} doesn't work reliably in recipe bodies
# Use explicit header instead: #!/usr/bin/env bash\n  set -euo pipefail\n  source "{{BASH_UTILS}}"

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
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_required bats "bats not installed; needed for 'just test-external'. Install with 'just tools-install' or via brew install bats-core" \
    bash -c "echo '> bats detected'; bats scripts/tests"

shellcheck: ## Run shellcheck on repo scripts if available
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_optional shellcheck \
    bash -c "echo '> shellcheck'; shellcheck -x scripts/*.sh || true"

yq-check: ## Show yq version and sample check
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_optional yq \
    yq --version

dotenv-lint: ## Lint .env with dotenv-linter if available
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_if_file_and_cmd .env dotenv-linter \
    dotenv-linter .env

direnv-allow: ## Allow direnv for this directory
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  if bu::have direnv; then
    direnv allow || true
  else
    echo "direnv not installed; skipping"
  fi

env: ## Print env via shdotenv if available
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  if [ ! -f .env ] && [ -x ./scripts/.env-generator.sh ]; then \
    echo "> generating .env"; \
    ./scripts/.env-generator.sh; \
  fi
  if bu::have shdotenv; then
    shdotenv -f .env -q -e || true
  else
    echo "shdotenv not installed; skipping"
  fi

healthcheck: ## Run repo healthcheck script
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_script scripts/healthcheck.sh

env-generate: ## Generate/update .env from .env.example (interactive for *_PASSWORD)
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  chmod +x ./scripts/.env-generator.sh || true
  ./scripts/.env-generator.sh

bashly-check: ## Show bashly version if installed
  #!/usr/bin/env bash
  set -euo pipefail
  source "{{BASH_UTILS}}"
  bu::run_required bashly "bashly not installed; required if you want to generate CLIs" \
    bash -c "echo '> bashly'; bashly --version"

tools-install: ## Install bash tooling (macOS Homebrew / Linux apt)
  bash scripts/tools/install-bash-tools.sh
