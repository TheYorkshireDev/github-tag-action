#!/usr/bin/env bats
export BATS_LIB_PATH=${BATS_LIB_PATH:-"/usr/lib"}
bats_load_library bats-support
bats_load_library bats-assert

setup() {
  TMP=$(mktemp -d)
  cd "$TMP"
  git init -b main >/dev/null
  git config user.name "Test"
  git config user.email "test@example.com"
  touch README && git add README && git commit -m "initial" >/dev/null
}

teardown() {
  rm -rf "$TMP"
}

run_entry() {
  bash "$BATS_TEST_DIRNAME/../entrypoint.sh"
}

@test "Creates a new tag with default settings (no prefix)" {
  run setup
  export DRY_RUN="true"
  run run_entry
  assert_success
  assert_line "Bumping tag 0.0.0 - New tag 0.5.0"
  run teardown
}

@test "Bumps a tag with default settings (no prefix)" {
  run setup
  git tag -a "1.0.0" -m "Initial tag" >/dev/null
  export DRY_RUN="true"
  run run_entry
  assert_success
  assert_line "Bumping tag 1.0.0 - New tag 1.1.0"
  run teardown
}

@test "Creates a new tag with v prefix" {
  run setup
  export DRY_RUN="true"
  export TAG_PREFIX="v"
  run run_entry
  assert_success
  assert_line "Bumping tag v0.0.0 - New tag v0.1.0"
  run teardown
}

@test "Bumps a new tag with v prefix" {
  run setup
  git tag -a "1.0.0" -m "Initial tag" >/dev/null
  export DRY_RUN="true"
  export TAG_PREFIX="v"
  run run_entry
  assert_success
  assert_line "Bumping tag v1.0.0 - New tag v1.1.0"
  run teardown
}
