#!/usr/bin/env bats
load 'bats-support/load.bash'
load 'bats-assert/load.bash'

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

@test "Fails gracefully when no tags exist" {
  run run_entry
  assert_failure
  assert_line "No existing tag found"
}

@test "Creates new tag when default bump 'patch'" {
  export INPUT_DEFAULT_BUMP="patch"
  export GITHUB_TOKEN="dummy"
  run run_entry
  assert_success
  # Expect tag v0.0.1 or similar printed
  assert_line "Created tag v0.0.1"
}
