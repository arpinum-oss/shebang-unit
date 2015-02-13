printf "some log in the file\n"

global_setup() {
  printf "some log in global setup\n"
}

global_teardown() {
  printf "some log in global teardown\n"
}

setup() {
  printf "some log in setup\n"
}

teardown() {
  printf "some log in teardown\n"
}

first_successful_test_function() {
  printf "some log in test\n"
  printf "some error log in test\n" >&2
}

second_successful_test_function() {
  :
}
