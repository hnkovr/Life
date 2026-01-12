#!/usr/bin/env bash
set -euo pipefail

# Small, dependency-free bash helpers used across repo scripts and Make/Just tasks.

# --- Colors (best-effort) ---
bu::_is_tty() { [ -t 1 ]; }
bu::_color() { bu::_is_tty && command -v tput >/dev/null 2>&1 && tput setaf "$1" 2>/dev/null || true; }
bu::_reset() { bu::_is_tty && command -v tput >/dev/null 2>&1 && tput sgr0 2>/dev/null || true; }

# --- Logging ---
bu::ts() { date '+%Y-%m-%d %H:%M:%S'; }
bu::log() { printf '%s %s%s%s %s\n' "$(bu::ts)" "$(bu::_color 2)" "INFO" "$(bu::_reset)" "$*"; }
bu::warn() { printf '%s %s%s%s %s\n' "$(bu::ts)" "$(bu::_color 3)" "WARN" "$(bu::_reset)" "$*"; }
bu::err() { printf '%s %s%s%s %s\n' "$(bu::ts)" "$(bu::_color 1)" "ERR " "$(bu::_reset)" "$*" 1>&2; }
bu::die() { bu::err "$*"; exit 1; }
bu::title() { printf '\n%s\n' "$*"; }

# --- Command helpers ---
BU_DEBUG="${BU_DEBUG:-0}"
bu::cmd() {
  local cmd=("$@")
  printf '%s %s\n' "$(bu::_color 4)+$(bu::_reset)" "${cmd[*]}"
  if [ "$BU_DEBUG" = "1" ]; then
    "${cmd[@]}" || bu::die "command failed: ${cmd[*]}"
  else
    "${cmd[@]}" >/dev/null 2>&1 || bu::die "command failed: ${cmd[*]}"
  fi
}

bu::have() { command -v "$1" >/dev/null 2>&1; }
bu::need() { local m; for m in "$@"; do bu::have "$m" || bu::die "missing required tool: $m"; done }

