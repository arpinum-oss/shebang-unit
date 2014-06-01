function global_setup() {
  _TESTS_DIRECTORY="${TESTS_RESOURCES_DIR}/runner/one_poorly_formated_test"
  _FUNCTIONS_DOCUMENT_KEY="called_functions"
}

function setup() {
	database__initialise
}

function teardown() {
  database__release
}

function the_runner_call_the_test_functions() {
	( configuration_load
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )
  local called_functions=($(_get_called_functions))

	assertion__equal 3 "${#called_functions[@]}"
	assertion__equal "well_formated_test_function" "${called_functions[0]}"
	assertion__equal "indented_test_function" "${called_functions[1]}"
	assertion__equal "inlined_test_function" "${called_functions[2]}"
}

function _get_called_functions() {
	database__get "${_FUNCTIONS_DOCUMENT_KEY}"
}

function _function_called() {
  database__post "${_FUNCTIONS_DOCUMENT_KEY}" "$1 "
}