function global_setup() {
  _TESTS_DIRECTORY="${TESTS_RESOURCES_DIR}/directory_with_one_test"
  _FUNCTIONS_DOCUMENT_KEY="called_functions"
	database__initialise
	( configuration_load
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )
 	  _called_functions=($(_get_called_functions) )
}

function global_teardown() {
  database__destroy
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

function _get_called_functions() {
	database__get "${_FUNCTIONS_DOCUMENT_KEY}"
}

function _function_called() {
  database__post "${_FUNCTIONS_DOCUMENT_KEY}" "$1 "
}