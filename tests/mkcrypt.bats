load 'helper'

setup() {
  setup_temp
}

teardown() {
  cleanup_temp
}

@test "test --help" {
  run ./src/mkcrypt --help
  assert_success
  assert_line --partial "Usage: mkcrypt"
}

@test "test error: no arg" {
  run ./src/mkcrypt

  assert_failure
  assert_output --partial "Filename required."
}

@test "test error: file exists" {
  filename="$TEST_TEMP_DIR/exists.txt.gpg"
  touch "$filename"
  run ./src/mkcrypt "$filename"

  assert_failure
  assert_output --partial "'${filename}' already exists."
}

@test "test success: with .gpg suffix" {
  filename="$TEST_TEMP_DIR/file.txt.gpg"

  run ./src/mkcrypt "$filename"

  assert_success
  assert_file_exist "${filename}"
}

@test "test success: without .gpg suffix" {
  name="$TEST_TEMP_DIR/file.txt"
  filename="${name}.gpg"

  run ./src/mkcrypt "$name"

  assert_success
  assert_file_exist "${filename}"
}

@test "test success: gpg command" {
  run ./src/mkcrypt --dry-run myfile.txt

  assert_success

  # this is how it really looks, but it's broken because of output redirection
  # "echo | gpg --encrypt --output myfile.txt.gpg

  # this is the trimmed down version
  assert_output --partial "gpg --encrypt --output myfile.txt.gpg"
}

@test "test success: passing gpg options" {
  run ./src/mkcrypt myfile.txt --dry-run --recipient somebody@somewhere

  assert_success

  # this is how it really looks, but it's broken because of output redirection
  # "echo | gpg --encrypt --output myfile.txt.gpg --recipient somebody@somewhere"

  # this is the trimmed down version
  assert_output --partial "gpg --encrypt --output myfile.txt.gpg --recipient somebody@somewhere"
}

@test "test success: passing gpg options before name" {
  run ./src/mkcrypt --dry-run --recipient somebody@somewhere myfile.txt

  assert_failure
  assert_output --partial "Unexpected option: '--recipient'."
}
