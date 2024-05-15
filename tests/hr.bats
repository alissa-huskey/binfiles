load 'helper'

@test "test help" {
  run ./src/hr --help
  assert_success
  assert_output --partial 'Usage: hr'
}

@test "test success: defaults" {
  run env COLUMNS=70 ./src/hr

  assert_success
  assert_output --regexp '^=+$'
  assert_equal ${#output} 70
}

@test "test success: width" {
  run ./src/hr --width 5
  assert_success
  assert_output '====='
}

@test "test success: margin" {
  run env COLUMNS=70 ./src/hr --margin 5

  assert_success
  assert_output --regexp '^=+$'
  assert_equal ${#output} 65
}

@test "test success: char" {
  for c in '.' '-' '*' '_' '~' '#' ; do
      run ./src/hr '-'

      assert_success
      assert_output --regexp '^-+$'
  done
}
