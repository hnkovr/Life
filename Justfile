# Variables
set shell := ["bash", "-euo", "pipefail", "-c"]

# Common bash script header
BASH_HEADER := '''#!/usr/bin/env bash
set -euo pipefail
'''

REPO_ROOT := `pwd`
HOME_LIFE := env_var("HOME") + "/life"
HOME_LIFE_DIR := env_var("HOME") + "/.life"
HOME_MAKE := env_var("HOME") + "/Makefile.life"
HOME_JUST := env_var("HOME") + "/Justfile.life"
BIN_DIR := env_var("HOME") + "/bin"

# Helper functions (private)
[private]
cmd cmd_name:
  #!/usr/bin/env bash
  set -euo pipefail
  command -v {{cmd_name}} >/dev/null 2>&1

[private]
die msg:
  #!/usr/bin/env bash
  set -euo pipefail
  echo "ERROR: {{msg}}" >&2
  exit 1

[private]
require_cmd cmd_name msg="":
  #!/usr/bin/env bash
  set -euo pipefail
  if ! command -v {{cmd_name}} >/dev/null 2>&1; then
    MSG="{{msg}}"
    if [ -z "$MSG" ]; then
      MSG="{{cmd_name}} is not installed"
    fi
    echo "ERROR: $MSG" >&2
    exit 1
  fi

[private]
optional_cmd cmd_name action skip_msg="":
  #!/usr/bin/env bash
  set -euo pipefail
  if command -v {{cmd_name}} >/dev/null 2>&1; then
    {{action}}
  else
    MSG="{{skip_msg}}"
    if [ -z "$MSG" ]; then
      MSG="{{cmd_name}} not installed; skipping"
    fi
    echo "$MSG"
  fi

[private]
func script_path args="":
  #!/usr/bin/env bash
  set -euo pipefail
  if [ -x {{script_path}} ] || [ -f {{script_path}} ]; then
    bash {{script_path}} {{args}} || true
  else
    echo "{{script_path}} not present"
  fi

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
  if ! command -v bats >/dev/null 2>&1; then
    echo "ERROR: bats not installed; needed for 'just test-external'" >&2
    echo "Install with 'just tools-install' or via brew install bats-core" >&2
    exit 1
  fi
  echo "> bats detected"
  bats scripts/tests

shellcheck: ## Run shellcheck on repo scripts if available
  #!/usr/bin/env bash
  set -euo pipefail
  if command -v shellcheck >/dev/null 2>&1; then
    echo "> shellcheck"
    shellcheck -x scripts/*.sh || true
  else
    echo "shellcheck not installed; skipping"
  fi

yq-check: ## Show yq version and sample check
  #!/usr/bin/env bash
  set -euo pipefail
  if command -v yq >/dev/null 2>&1; then
    yq --version
  else
    echo "yq not installed; skipping"
  fi

dotenv-lint: ## Lint .env with dotenv-linter if available
  #!/usr/bin/env bash
  set -euo pipefail
  if [ -f .env ] && command -v dotenv-linter >/dev/null 2>&1; then
    dotenv-linter .env
  else
    echo "dotenv-linter not installed or .env missing; skipping"
  fi

direnv-allow: ## Allow direnv for this directory
  #!/usr/bin/env bash
  set -euo pipefail
  if command -v direnv >/dev/null 2>&1; then
    direnv allow || true
  else
    echo "direnv not installed; skipping"
  fi

env: ## Print env via shdotenv if available
  #!/usr/bin/env bash
  set -euo pipefail
  if [ ! -f .env ] && [ -x ./scripts/.env-generator.sh ]; then
    echo "> generating .env"
    ./scripts/.env-generator.sh
  fi
  if command -v shdotenv >/dev/null 2>&1; then
    shdotenv -f .env -q -e || true
  else
    echo "shdotenv not installed; skipping"
  fi

healthcheck: ## Run repo healthcheck script
  #!/usr/bin/env bash
  set -euo pipefail
  if [ -x scripts/healthcheck.sh ] || [ -f scripts/healthcheck.sh ]; then
    bash scripts/healthcheck.sh || true
  else
    echo "scripts/healthcheck.sh not present"
  fi

env-generate: ## Generate/update .env from .env.example (interactive for *_PASSWORD)
  #!/usr/bin/env bash
  set -euo pipefail
  chmod +x ./scripts/.env-generator.sh || true
  ./scripts/.env-generator.sh

bashly-check: ## Show bashly version if installed
  #!/usr/bin/env bash
  set -euo pipefail
  if ! command -v bashly >/dev/null 2>&1; then
    echo "ERROR: bashly not installed; required if you want to generate CLIs" >&2
    exit 1
  fi
  echo "> bashly"
  bashly --version

tools-install: ## Install bash tooling (macOS Homebrew / Linux apt)
  bash scripts/tools/install-bash-tools.sh
