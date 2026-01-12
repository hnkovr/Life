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

# --- High-level command patterns for Make/Just ---

# Run command if tool exists, otherwise skip with message
# Usage: bu::run_optional toolname [skip_msg] command [args...]
#   If skip_msg is omitted, uses default: "$tool not installed; skipping"
bu::run_optional() {
  local tool="$1"
  shift
  local skip_msg=""

  # Check if first arg after tool is a message (not a command/path)
  if [ $# -gt 0 ] && [[ "$1" != /* ]] && [[ "$1" != ./* ]] && ! command -v "$1" >/dev/null 2>&1; then
    skip_msg="$1"
    shift
  fi

  if bu::have "$tool"; then
    "$@"
  else
    echo "${skip_msg:-$tool not installed; skipping}"
  fi
}

# Run command if tool exists, otherwise die with message
# Usage: bu::run_required toolname [err_msg] command [args...]
#   If err_msg is omitted, uses default: "$tool is required but not installed"
bu::run_required() {
  local tool="$1"
  shift
  local err_msg=""

  # Check if first arg after tool is a message (not a command/path)
  if [ $# -gt 0 ] && [[ "$1" != /* ]] && [[ "$1" != ./* ]] && ! command -v "$1" >/dev/null 2>&1; then
    err_msg="$1"
    shift
  fi

  if ! bu::have "$tool"; then
    bu::die "${err_msg:-$tool is required but not installed}"
  fi
  "$@"
}

# Run script if it exists (executable or readable)
# Usage: bu::run_script script_path [args...]
bu::run_script() {
  local script="$1"
  shift
  if [ -x "$script" ] || [ -f "$script" ]; then
    bash "$script" "$@" || true
  else
    echo "$script not present"
  fi
}

# Run command only if both file and tool exist
# Usage: bu::run_if_file_and_cmd filepath toolname [skip_msg] command [args...]
#   If skip_msg is omitted, uses default: "$tool not installed or $file missing; skipping"
bu::run_if_file_and_cmd() {
  local file="$1"
  local tool="$2"
  shift 2
  local skip_msg=""

  # Check if first arg after tool is a message (not a command/path)
  if [ $# -gt 0 ] && [[ "$1" != /* ]] && [[ "$1" != ./* ]] && ! command -v "$1" >/dev/null 2>&1; then
    skip_msg="$1"
    shift
  fi

  if [ -f "$file" ] && bu::have "$tool"; then
    "$@"
  else
    echo "${skip_msg:-$tool not installed or $file missing; skipping}"
  fi
}

