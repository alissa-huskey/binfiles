load 'helper'

setup() {
  setup_temp
}

teardown() {
  cleanup_temp
}

@test "test help" {
  run ./src/jqfmt --help
  assert_success
}

@test "test error: missing arg" {
  run ./src/jqfmt 
  assert_failure
  assert_line --partial "Missing required argument: filepath"
}


@test "test error: no such file" {
  run ./src/jqfmt "missing.json"
  assert_failure
  assert_line --partial "No such file: missing.json"
}

@test "test error: empty file" {
  filename="$TEST_TEMP_DIR/empty.json"
  touch "${filename}"
  run ./src/jqfmt "${filename}"
  assert_failure
  assert_line --partial "File is empty"
}

@test "test success" {
  filename="$TEST_TEMP_DIR/file.json"
  echo "[1,2,3,4,5]" > "${filename}"
  run ./src/jqfmt "${filename}"
  assert_success

  run wc -l "${filename}"
  assert_output "7 ${filename}"
}
