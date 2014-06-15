function global_setup() {
  _TESTS_DIRECTORY="${TESTS_RESOURCES_DIR}/runner/directory_with_tests_only"
  helper__use_silent_reporter
}

function setup() {
	database__initialise
}

function teardown() {
  database__release
}

function can_execute_function_for_a_given_pattern() {
  SBU_TEST_FUNCTION_PATTERN="my_*"

  runner__run_all_test_files "${_TESTS_DIRECTORY}"

  _called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#_called_functions[@]}"
	assertion__array_contains "my_test_function" "${_called_functions[0]}"
	assertion__array_contains "my_other_test_function" "${_called_functions[1]}"
}