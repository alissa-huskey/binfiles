load 'helper'

@test "test --help" {
  run ./src/zman --help
  assert_success
}

@test "test --list" {
  run ./src/zman --list
  assert_line --partial "ZSH Manual Chapters"
}

@test "test chapter exists" {
  run ./src/zman roadmap

  assert_success
  assert_line --partial "ZSHROADMAP"
}

@test "test search" {
  # can't really do much to test this since the functionality is within less
  # not even the run command, because it will hang waiting on user input
  assert ./src/zman zmv > /dev/null
}
