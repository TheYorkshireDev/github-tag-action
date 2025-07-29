#!/usr/bin/env bats
export BATS_LIB_PATH=${BATS_LIB_PATH:-"/usr/lib"}
bats_load_library bats-support
bats_load_library bats-assert

setup() {
  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  # make executables in root visible to PATH
  export PATH="$DIR/../:$PATH"

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

@test "Creates a new tag with default settings (no prefix)" {
  # Arrange
  run setup
  export SOURCE=$(pwd)
  export DRY_RUN="true"
  pwd
  git status
  ls -al

  # Act
  entrypoint.sh

  # Assert
  assert_success
  assert_line "Bumping tag 0.0.0 - New tag 0.1.0"
  run teardown
}


