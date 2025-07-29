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
  # Arrange
  run setup
  export SOURCE="../../../../..$(pwd)" # Workaround for "GITHUB_WORKSPACE" prefix in script
  export DRY_RUN="true"
  pwd
  git status
  ls -al

  # Act
  run run_entry

  # Assert
  assert_success
  assert_line "Bumping tag 0.0.0 - New tag 0.1.0"
  run teardown
}


