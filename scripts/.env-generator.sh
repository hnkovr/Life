#!/usr/bin/env bash
set -euo pipefail

TARGET_FILE=".env"
EXAMPLE_FILE=".env.example"

usage() {
  cat <<EOF
Usage: $0 [-p <password>] [-pp <host1>=<pwd1> <host2>=<pwd2> ...] [--file <path>] [--example <path>]

Initializes or updates $TARGET_FILE by filling empty *_PASSWORD and *_KEY entries.

Options:
  -p <password>                Use one password for all empty password/key vars.
  -pp <host>=<pwd> [...]       Supply per-host passwords (host taken from corresponding *_HOST values).
  --file <path>                Target env file (default: .env)
  --example <path>             Example env file (default: .env.example)
  -h, --help                   Show this help and exit.

Behavior:
  - If target file does not exist, it is created from the example file if available
    (or created empty otherwise).
  - For each empty VAR ending with _PASSWORD or _KEY, the script will try in order:
      1) Match its corresponding PREFIX_HOST value against -pp mappings and use that password
      2) Use the -p default password if provided
      3) Prompt interactively (hidden input)
  - Existing non-empty passwords/keys are left unchanged.
EOF
}

# --- Argument parsing ---
COMMON_PWD=""
HOST_PWD_MAP=()  # elements like "host=pwd"

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -p)
      shift || { echo "Error: -p requires a value" >&2; exit 2; }
      COMMON_PWD="${1:-}"
      if [[ -z "$COMMON_PWD" ]]; then
        echo "Error: -p requires a non-empty password" >&2
        exit 2
      fi
      shift
      ;;
    -pp)
      shift
      # Collect host=pwd pairs until next option or end
      while [[ $# -gt 0 && "$1" != "-p" && "$1" != "-pp" && "$1" != "--" && "$1" != "--file" && "$1" != "--example" ]]; do
        HOST_PWD_MAP+=("$1")
        shift
      done
      ;;
    --file)
      shift || { echo "Error: --file requires a value" >&2; exit 2; }
      TARGET_FILE="${1:-}"; shift
      ;;
    --example)
      shift || { echo "Error: --example requires a value" >&2; exit 2; }
      EXAMPLE_FILE="${1:-}"; shift
      ;;
    -h|--help)
      usage; exit 0
      ;;
    --)
      shift; break
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage; exit 2
      ;;
  esac
done

# --- Helpers (adapted from referenced secrets initializer) ---
trim() { awk '{gsub(/^\s+|\s+$/,"",$0); print}' <<<"$1"; }

escape_sed_replacement() {
  # Escape & and \ for sed replacement; use | as delimiter to avoid /
  printf '%s' "$1" | sed -e 's/[&\\]/\\&/g'
}

get_var_line() {
  # Print the last assignment line for a VAR from file (ignoring comments)
  local var="$1" file="$2"
  grep -E "^${var}[[:space:]]*=" -n "$file" | tail -n1 || true
}

get_var_value() {
  local var="$1" file="$2"
  local line
  line=$(get_var_line "$var" "$file") || true
  if [[ -z "$line" ]]; then
    echo ""
    return 0
  fi
  local content
  content="${line#*=}"
  echo "$content"
}

is_empty_value() {
  # Consider empty if value is empty or "" or '' (optionally surrounded by whitespace)
  local v
  v="$(trim "$1")"
  if [[ -z "$v" || "$v" == "''" || "$v" == '""' ]]; then
    return 0
  fi
  return 1
}

set_var_value() {
  local var="$1" value="$2" file="$3"
  local escaped
  escaped=$(escape_sed_replacement "$value")
  if grep -q -E "^${var}[[:space:]]*=" "$file"; then
    sed -i.bak -E "s|^${var}[[:space:]]*=.*$|${var}=${escaped}|" "$file"
  else
    printf '\n%s=%s\n' "$var" "$value" >> "$file"
  fi
}

lookup_host_pwd() {
  local host="$1"
  local pair
  for pair in "${HOST_PWD_MAP[@]:-}"; do
    local k="${pair%%=*}"
    local v="${pair#*=}"
    if [[ "$k" == "$host" ]]; then
      echo "$v"
      return 0
    fi
  done
  return 1
}

# --- Ensure target file exists ---
if [[ ! -f "$TARGET_FILE" ]]; then
  if [[ -f "$EXAMPLE_FILE" ]]; then
    cp "$EXAMPLE_FILE" "$TARGET_FILE"
    echo "Created $TARGET_FILE from $EXAMPLE_FILE"
  else
    echo "Warning: $EXAMPLE_FILE not found; creating empty $TARGET_FILE" >&2
    : > "$TARGET_FILE"
  fi
fi

# Lock down permissions early
chmod 600 "$TARGET_FILE" 2>/dev/null || true

# --- Collect password and key variables ---
mapfile -t PASSWORD_VARS < <(grep -E '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*_(PASSWORD|KEY)[[:space:]]*=' "$TARGET_FILE" | \
  sed -E 's/^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=.*/\1/' | uniq)

if [[ ${#PASSWORD_VARS[@]} -eq 0 ]]; then
  echo "No *_PASSWORD or *_KEY variables found in $TARGET_FILE. Nothing to do."
  exit 0
fi

echo "Scanning ${#PASSWORD_VARS[@]} password/key variables in $TARGET_FILE..."

UPDATED_COUNT=0
SKIPPED_COUNT=0

for var in "${PASSWORD_VARS[@]}"; do
  current_value="$(get_var_value "$var" "$TARGET_FILE")"
  if ! is_empty_value "$current_value"; then
    continue
  fi

  # Determine prefix by removing either _PASSWORD or _KEY suffix
  if [[ "$var" == *_PASSWORD ]]; then
    prefix="${var%_PASSWORD}"
  elif [[ "$var" == *_KEY ]]; then
    prefix="${var%_KEY}"
  else
    # Should not happen given the grep pattern, but be safe
    echo "Warning: Variable $var does not end with _PASSWORD or _KEY, skipping" >&2
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    continue
  fi

  host_var="${prefix}_HOST"
  host_value="$(get_var_value "$host_var" "$TARGET_FILE" | tr -d '\r')"
  host_value_trimmed="$(trim "$host_value")"

  decided_pwd=""

  if [[ -n "$host_value_trimmed" ]]; then
    map_pwd="$(lookup_host_pwd "$host_value_trimmed" || true)"
    if [[ -n "$map_pwd" ]]; then
      decided_pwd="$map_pwd"
    fi
  fi

  if [[ -z "$decided_pwd" && -n "$COMMON_PWD" ]]; then
    decided_pwd="$COMMON_PWD"
  fi

  if [[ -z "$decided_pwd" ]]; then
    if [[ -n "$host_value_trimmed" ]]; then
      prompt="Enter value for ${var} (host ${host_value_trimmed}): "
    else
      prompt="Enter value for ${var}: "
    fi
    read -r -s -p "$prompt" input_pwd
    echo ""
    decided_pwd="$input_pwd"
  fi

  if [[ -n "$decided_pwd" ]]; then
    set_var_value "$var" "$decided_pwd" "$TARGET_FILE"
    UPDATED_COUNT=$((UPDATED_COUNT + 1))
    if [[ -n "$host_value_trimmed" ]]; then
      echo "Set $var for host $host_value_trimmed"
    else
      echo "Set $var"
    fi
  else
    SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    echo "Skipped $var (left empty)"
  fi
done

# Clean up sed backup if created
[[ -f "${TARGET_FILE}.bak" ]] && rm -f "${TARGET_FILE}.bak"

# Final permissions
chmod 600 "$TARGET_FILE" 2>/dev/null || true

echo "Done. Updated: ${UPDATED_COUNT}, Skipped: ${SKIPPED_COUNT}. File: $TARGET_FILE"

