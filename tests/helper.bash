for lib in support assert file; do
  load $(brew --prefix bats-$lib)/lib/bats-$lib/load.bash
done

BATSLIB_TEMP_PRESERVE=1    # preserve temp dir on fail
HOST="http://localhost:1313"

p() {
  echo "# ${*}" >&3
}

setup_temp() {
   # requires bats-file
   # create a temp directory
   TEST_TEMP_DIR="$(temp_make --prefix 'jqcurl-')"

   # in test output replace path to tempdir with "<temp>"
   BATSLIB_FILE_PATH_REM="#${TEST_TEMP_DIR}"
   BATSLIB_FILE_PATH_ADD='$TESTDIR'
}

cleanup_temp() {
   # requires bats-file
  temp_del "$TEST_TEMP_DIR"
}

stop_server() {
  curl --request POST "${HOST}/close" 2> /dev/null || :
}

start_server() {
  stop_server
  ${BATS_TEST_DIRNAME}/data/mock-server ${1:+"$@"} 2>/dev/null &
  sleep 1
}

