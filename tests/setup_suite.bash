source "$BATS_TEST_DIRNAME/helper.bash"

setup_suite() {
  start_server
}

teardown_suite() {
  stop_server
}
