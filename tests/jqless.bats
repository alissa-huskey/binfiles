load 'helper'

setup() {
  setup_temp
}

teardown() {
  cleanup_temp
}

@test "test error: missing arg" {
  run ./src/jqless 
  assert_failure
  assert_line --partial "Filename required"
}

@test "test success" {
  filename="$TEST_TEMP_DIR/file.json"
  echo "[1,2,3,4,5]" > "${filename}"
  run ./src/jqless "${filename}"
  assert_success

  assert_equal ${#lines[@]} 7
}
