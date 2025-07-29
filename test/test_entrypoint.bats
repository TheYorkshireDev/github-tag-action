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

@test "Creates a new tag with default settings" {
  export INPUT_DRY_RUN="true"
  run run_entry
  assert_success
  assert_line "Created tag v0.0.1"
}

@test "Creates new tag when default bump 'patch'" {
  export INPUT_DEFAULT_BUMP="patch"
  export GITHUB_TOKEN="dummy"
  run run_entry
  assert_success
  # Expect tag v0.0.1 or similar printed
  assert_line "Created tag v0.0.1"
}
