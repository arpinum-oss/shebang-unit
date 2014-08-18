function global_setup() {
  _TESTS_DIRECTORY="${TESTS_RESOURCES_DIR}/runner/directory_with_one_test"
  helper__use_silent_reporter
  database__initialise
  ( runner__run_all_test_files "${_TESTS_DIRECTORY}" )
  _called_functions=($(helper__get_called_functions))
}

function global_teardown() {
  database__release
}

function the_runner_call_the_global_setup() {
  assertion__array_contains "global_setup" "${_called_functions[@]}"
}

function the_runner_call_the_global_teardown() {
  assertion__array_contains "global_teardown" "${_called_functions[@]}"
}

function the_runner_call_the_setup() {
  assertion__array_contains "setup" "${_called_functions[@]}"
}

function the_runner_call_the_teardown() {
  assertion__array_contains "teardown" "${_called_functions[@]}"
}

function the_runner_call_the_test_functions() {
  assertion__array_contains "first_test_function" "${_called_functions[@]}"
  assertion__array_contains "second_test_function" "${_called_functions[@]}"
}

function the_runner_call_functions_in_the_right_order() {
  assertion__equal "global_setup" "${_called_functions[0]}"
  assertion__equal "setup" "${_called_functions[1]}"
  assertion__equal "first_test_function" "${_called_functions[2]}"
  assertion__equal "teardown" "${_called_functions[3]}"
  assertion__equal "setup" "${_called_functions[4]}"
  assertion__equal "second_test_function" "${_called_functions[5]}"
  assertion__equal "teardown" "${_called_functions[6]}"
  assertion__equal "global_teardown" "${_called_functions[7]}"
  assertion__equal 8 "${#_called_functions[@]}"
}