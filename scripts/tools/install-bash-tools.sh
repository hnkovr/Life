#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "${DIR}/../.." && pwd -P)"
# shellcheck disable=SC1091
source "${REPO_ROOT}/scripts/lib/bash-utils.sh" 2>/dev/null || {
  echo "[WARN] bash-utils not found; proceeding without pretty logs" >&2
  bu::log() { echo "[INFO] $*"; }
  bu::warn() { echo "[WARN] $*"; }
  bu::die() { echo "[ERR]  $*" >&2; exit 1; }
}

on_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    bu::die "Homebrew not found. Install from https://brew.sh first."
  fi
  bu::log "Installing tools via Homebrew"
  bu::cmd brew update
  bu::cmd brew install bats-core shellcheck yq direnv dotenv-linter || true
  bu::cmd brew install bashly || true
  bu::cmd brew tap ko1nksm/tap || true
  bu::cmd brew install ko1nksm/tap/shdotenv || bu::warn "shdotenv install via brew failed; see https://github.com/ko1nksm/shdotenv"

  # log4bash: not packaged commonly; provide hint
  local prefix
  prefix="$(brew --prefix 2>/dev/null || echo "$HOME/.local")"
  local dest="${prefix}/lib/log4bash/log4bash.sh"
  if [ ! -f "$dest" ]; then
    bu::warn "log4bash not installed by package manager. To enable, place log4bash.sh at: $dest"
    bu::warn "Example (manual): mkdir -p \"$(dirname "$dest")\" && curl -fsSL <repo_raw_url>/log4bash.sh -o \"$dest\""
  else
    bu::log "log4bash present at $dest"
  fi
}

on_linux() {
  if command -v apt-get >/dev/null 2>&1; then
    bu::log "Installing tools via apt-get"
    bu::cmd sudo apt-get update
    bu::cmd sudo apt-get install -y bats shellcheck direnv ruby-full git curl || true
    # yq via snap or binary
    if command -v snap >/dev/null 2>&1; then
      bu::cmd sudo snap install yq || bu::warn "Failed to install yq via snap"
    else
      bu::warn "Install yq manually: https://github.com/mikefarah/yq#install"
    fi
    # dotenv-linter via cargo if available
    if command -v cargo >/dev/null 2>&1; then
      bu::cmd cargo install dotenv-linter || true
    else
      bu::warn "Install dotenv-linter (requires cargo): https://github.com/dotenv-linter/dotenv-linter"
    fi
    # bashly via gem
    bu::cmd sudo gem install bashly || bu::warn "gem install bashly failed"
    # shdotenv via manual script
    bu::warn "Install shdotenv: https://github.com/ko1nksm/shdotenv (binary/script install)"
    # log4bash guidance
    bu::warn "Install log4bash manually and place it under /usr/local/lib/log4bash/log4bash.sh"
  else
    bu::die "Unsupported Linux package manager; please install tools manually."
  fi
}

main() {
  case "$(uname -s)" in
    Darwin) on_macos ;;
    Linux) on_linux ;;
    *) bu::die "Unsupported OS: $(uname -s)" ;;
  esac

  bu::log "Tool versions (if installed):"
  for t in bats shellcheck yq direnv dotenv-linter shdotenv bashly; do
    if command -v "$t" >/dev/null 2>&1; then "$t" --version 2>/dev/null || "$t" -V 2>/dev/null || true; fi
  done
}

main "$@"

