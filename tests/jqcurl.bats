load 'helper'

setup() {
  setup_temp
}

teardown() {
  cleanup_temp
}

@test "test help" {
  run ./src/jqcurl --help
  assert_success
}

@test "test error: no URL" {
  run ./src/jqcurl 
  assert_failure
  assert_output --partial "Please provide a URL."
}

@test "test error: failed request" {
  run ./src/jqcurl xxx
  assert_failure
  assert_output --partial "Request failed."
}

@test "test error: unsuccessful response" {
  run ./src/jqcurl "${HOST}/no-such-thing.json"
  assert_failure
  assert_output --partial "Request failed: '404 File not found'."
}

@test "test error: not JSON" {
  run ./src/jqcurl "${HOST}/page.html"
  assert_failure
  assert_output --partial "Mime type is not JSON but: 'text/html'."
}

@test "test error: blank mimetype, not JSON" {
  run ./src/jqcurl "${HOST}/page.html"
  assert_failure
  assert_output --partial "Mime type is not JSON but: 'text/html'."
}

@test "test error: empty file" {
  run ./src/jqcurl "${HOST}/blank.json"
  assert_failure
  assert_output --partial "The JSON content is blank."
}

@test "test error: invalid JSON" {
  run ./src/jqcurl "${HOST}/invalid.json"
  assert_failure
  assert_output --partial "JSON formatting is invalid."
}

@test "test success" {
  run ./src/jqcurl "${HOST}/response.json"
  assert_success
  assert_line --regexp '"success".*: .*true.*,'
  assert_line --regexp '"deck_id".*: .*"eok8wuy8lwgg".*,'
  assert_line --regexp '"value".*: .*"JACK".*,'
  assert_line --regexp '"suit".*: .*"SPADES"'
  assert_line --regexp '"remaining".*: .*33'
}
