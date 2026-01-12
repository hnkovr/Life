#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd -- "$(dirname -- "${BATS_TEST_FILENAME}")"/../.. && pwd -P)"
  SCRIPT="$REPO_ROOT/scripts/life.sh"
  TMPDIR="$REPO_ROOT/scripts/tests/tmp/bats.$(date +%s%N)"
  mkdir -p "$TMPDIR/home"
  export HOME="$TMPDIR/home"
}

teardown() {
  rm -rf "$TMPDIR" || true
}

@test "symlink mode creates expected links" {
  run bash "$SCRIPT" links create --mode symlink --force \
    --home-life "$HOME/life" \
    --home-life-dir "$HOME/.life" \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  [ "$status" -eq 0 ]
  [ -L "$HOME/.life" ]
  [ -L "$HOME/life" ]
  [ -e "$HOME/Makefile.life" ]
  [ -e "$HOME/Justfile.life" ]
}

@test "remove cleans created links" {
  bash "$SCRIPT" links create --mode symlink --force \
    --home-life "$HOME/life" \
    --home-life-dir "$HOME/.life" \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  run bash "$SCRIPT" links remove \
    --home-life "$HOME/life" \
    --home-life-dir "$HOME/.life" \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  [ "$status" -eq 0 ]
  [ ! -e "$HOME/.life" ]
  [ ! -e "$HOME/life" ]
  [ ! -e "$HOME/Makefile.life" ]
  [ ! -e "$HOME/Justfile.life" ]
}

@test "hardlink mode creates file links only" {
  run bash "$SCRIPT" links create --mode hardlink --force \
    --home-make "$HOME/Makefile.life" \
    --home-just "$HOME/Justfile.life"
  [ "$status" -eq 0 ]
  [ -e "$HOME/Makefile.life" ]
  [ -e "$HOME/Justfile.life" ]
}

