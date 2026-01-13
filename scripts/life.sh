#!/usr/bin/env bash
set -euo pipefail

# Determine repo root (two levels up from this script)
LIFE_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
LIFE_REPO_ROOT="$(cd -- "${LIFE_SCRIPT_DIR}/.." && pwd -P)"

# Optional: load .env via shdotenv if present and source bash utils
life::load_env() {
  if command -v shdotenv >/dev/null 2>&1; then
    # Load quietly; ignore missing .env
    shdotenv -f "${LIFE_REPO_ROOT}/.env" -q -- env >/dev/null || true
  fi
}

# Logging helpers (optionally integrate with log4bash if available)
if [ -f "${LIFE_REPO_ROOT}/scripts/lib/bash-utils.sh" ]; then
  # shellcheck disable=SC1091
  source "${LIFE_REPO_ROOT}/scripts/lib/bash-utils.sh"
  life::log() { bu::log "$@"; }
  life::die() { bu::die "$@"; }
else
  life::log() { printf "[%s] %s\n" "${1:-INFO}" "${2:-}"; }
  life::die() { life::log "ERR" "$*" >&2; exit 1; }
fi

life::maybe_init_log4bash() {
  # If a log4bash initializer is available, use it; otherwise fallback to our logger
  if declare -F log4bash_init >/dev/null 2>&1; then
    log4bash_init || true
  elif [ -f /usr/local/lib/log4bash/log4bash.sh ]; then
    # common path, best-effort
    # shellcheck disable=SC1091
    source /usr/local/lib/log4bash/log4bash.sh || true
  elif [ -f /opt/homebrew/lib/log4bash/log4bash.sh ]; then
    # Apple Silicon Homebrew
    # shellcheck disable=SC1091
    source /opt/homebrew/lib/log4bash/log4bash.sh || true
  fi
}

life::usage() {
  cat <<'USAGE'
Usage:
  life.sh links create [--mode symlink|hardlink] [--force] \
    [--home-life PATH] [--home-life-dir PATH] [--home-make PATH] [--home-just PATH]
  life.sh links remove \
    [--home-life PATH] [--home-life-dir PATH] [--home-make PATH] [--home-just PATH]
  life.sh help | --help | -h

Notes:
  - symlink mode: creates symlinks to this repo and helper files.
  - hardlink mode: only links files (Makefile/Justfile).
  - Can be sourced: `source scripts/life.sh; life::selftest`.
USAGE
}

life::abs_dirname() { (
  cd -- "${1%/}" 2>/dev/null && pwd -P || printf '%s' "$1"
) }

life::mklink() {
  # mklink MODE target linkpath [--force]
  local mode="${1:?mode}" target="${2:?target}" linkpath="${3:?linkpath}" force_flag="${4:-}"
  mkdir -p -- "$(dirname -- "$linkpath")"
  case "$mode" in
    symlink)
      if [ -L "$linkpath" ] || [ -e "$linkpath" ]; then
        if [ "$force_flag" = "--force" ]; then rm -rf -- "$linkpath"; else return 0; fi
      fi
      ln -s -- "$target" "$linkpath"
      ;;
    hardlink)
      [ -f "$target" ] || life::die "hardlink requires file target: $target"
      if [ -e "$linkpath" ]; then
        if [ "$force_flag" = "--force" ]; then rm -f -- "$linkpath"; else return 0; fi
      fi
      ln "$target" "$linkpath"
      ;;
    *) life::die "unknown link mode: $mode" ;;
  esac
}

life::rm_if_exists() {
  local p; for p in "$@"; do [ -L "$p" ] || [ -e "$p" ] && rm -rf -- "$p" || true; done
}

life::links_create() {
  local mode="symlink" force=""
  local home_life="$HOME/life"
  local home_life_dir="$HOME/.life"
  local home_make="$HOME/Makefile.life"
  local home_just="$HOME/Justfile.life"

  while [ $# -gt 0 ]; do
    case "$1" in
      --mode) mode="${2:?}"; shift 2;;
      --force) force="--force"; shift;;
      --home-life) home_life="${2:?}"; shift 2;;
      --home-life-dir) home_life_dir="${2:?}"; shift 2;;
      --home-make) home_make="${2:?}"; shift 2;;
      --home-just) home_just="${2:?}"; shift 2;;
      *) life::die "unknown option for links create: $1";;
    esac
  done

  life::log INFO "Creating links (mode=$mode)"
  if [ "$mode" = symlink ]; then
    life::mklink symlink "$LIFE_REPO_ROOT" "$home_life_dir" "$force"
    life::mklink symlink "$LIFE_REPO_ROOT" "$home_life" "$force"
  fi
  # File links for both modes
  life::mklink "$mode" "$LIFE_REPO_ROOT/Makefile" "$home_make" "$force"
  life::mklink "$mode" "$LIFE_REPO_ROOT/Justfile" "$home_just" "$force"
  life::log INFO "Done"
}

life::links_remove() {
  local home_life="$HOME/life"
  local home_life_dir="$HOME/.life"
  local home_make="$HOME/Makefile.life"
  local home_just="$HOME/Justfile.life"

  while [ $# -gt 0 ]; do
    case "$1" in
      --home-life) home_life="${2:?}"; shift 2;;
      --home-life-dir) home_life_dir="${2:?}"; shift 2;;
      --home-make) home_make="${2:?}"; shift 2;;
      --home-just) home_just="${2:?}"; shift 2;;
      *) life::die "unknown option for links remove: $1";;
    esac
  done

  life::log INFO "Removing links"
  life::rm_if_exists "$home_life" "$home_life_dir" "$home_make" "$home_just"
  life::log INFO "Done"
}

# Minimal assertions for self-test without external deps
life::assert_exists() { [ -e "$1" ] || life::die "expected to exist: $1"; }
life::assert_symlink() { [ -L "$1" ] || life::die "expected symlink: $1"; }
life::assert_not_exists() { [ ! -e "$1" ] || life::die "expected not to exist: $1"; }

life::selftest() {
  life::log INFO "Selftest starting"
  local tmp_root="${LIFE_REPO_ROOT}/scripts/tests/tmp/selftest.$(date +%s%N)"
  mkdir -p "$tmp_root/home"
  local old_home="$HOME"; export HOME="$tmp_root/home"

  # Symlink mode
  bash "$LIFE_SCRIPT_DIR/life.sh" links create --mode symlink --force \
    --home-life "$HOME/life" \
    --home-life-dir "$HOME/.life" \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  life::assert_symlink "$HOME/.life"
  life::assert_symlink "$HOME/life"
  life::assert_exists "$HOME/Makefile.life"
  life::assert_exists "$HOME/Justfile.life"

  # Remove
  bash "$LIFE_SCRIPT_DIR/life.sh" links remove \
    --home-life "$HOME/life" \
    --home-life-dir "$HOME/.life" \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  life::assert_not_exists "$HOME/.life"
  life::assert_not_exists "$HOME/life"
  life::assert_not_exists "$HOME/Makefile.life"
  life::assert_not_exists "$HOME/Justfile.life"

  # Hardlink mode (files only)
  bash "$LIFE_SCRIPT_DIR/life.sh" links create --mode hardlink --force \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  life::assert_exists "$HOME/Makefile.life"
  life::assert_exists "$HOME/Justfile.life"

  # Clean
  bash "$LIFE_SCRIPT_DIR/life.sh" links remove \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  life::assert_not_exists "$HOME/Makefile.life"
  life::assert_not_exists "$HOME/Justfile.life"

  export HOME="$old_home"
  life::log INFO "Selftest ok"
}

life::main() {
  life::maybe_init_log4bash
  life::load_env || true

  local sub="${1:-}"; [ -n "$sub" ] || { life::usage; return 0; }
  case "$sub" in
    links)
      shift
      case "${1:-}" in
        create) shift; life::links_create "$@" ;;
        remove) shift; life::links_remove "$@" ;;
        * ) life::usage; return 1 ;;
      esac
      ;;
    help|-h|--help) life::usage ;;
    selftest) life::selftest ;;
    *) life::usage; return 1 ;;
  esac
}

# If sourced, provide functions only; if executed, run main
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  life::main "$@"
else
  # exported functions available to caller
  :
fi
A