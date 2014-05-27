function global_setup() {
  _TESTS_DIRECTORY="${TESTS_RESOURCES_DIR}/directory_for_failures_tests"
  _FUNCTIONS_DOCUMENT_KEY="called_functions"
}

function setup() {
	database_initialise
}

function teardown() {
  database_destroy
}

#ignore
function _the_runner_calls_global_teardown_if_global_setup_fails() {
  ( configuration_load
	  SBU_TEST_FILE_PATTERN="*file_with_failing_global_setup.sh"
  	runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "global_setup" "${called_functions[0]}"
	assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_stops_file_execution_if_global_setup_exits() {
  ( configuration_load
	  SBU_TEST_FILE_PATTERN="*file_with_exiting_global_setup.sh"
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 1 "${#called_functions[@]}"
	assertion__equal "global_setup" "${called_functions[0]}"
}

function the_runner_calls_global_teardown_if_test_fails() {
  _the_runner_calls_global_teardown_if_test_fails_or_exits \
    "file_with_failing_test.sh"
}

function the_runner_calls_global_teardown_if_test_exits() {
  _the_runner_calls_global_teardown_if_test_fails_or_exits \
    "file_with_exiting_test.sh"
}

function _the_runner_calls_global_teardown_if_test_fails_or_exits() {
	( configuration_load
	  SBU_TEST_FILE_PATTERN="*$1"
  	runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "failing_test_function" "${called_functions[0]}"
	assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_calls_teardown_if_setup_fails() {
  ( configuration_load
	  SBU_TEST_FILE_PATTERN="*file_with_failing_setup.sh"
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "setup" "${called_functions[0]}"
	assertion__equal "teardown" "${called_functions[1]}"
}

function the_runner_stops_test_execution_if_setup_exists() {
  ( configuration_load
	  SBU_TEST_FILE_PATTERN="*file_with_exiting_setup.sh"
  	runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 1 "${#called_functions[@]}"
	assertion__equal "setup" "${called_functions[0]}"
}

function _the_runner_calls_teardown_if_setup_fails_or_exits() {
	( configuration_load
	  SBU_TEST_FILE_PATTERN="*$1"
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "setup" "${called_functions[0]}"
	assertion__equal "teardown" "${called_functions[1]}"
}

function the_runner_call_teardown_if_test_fails() {
  _the_runner_call_teardown_if_test_fails_or_exits \
    "file_with_failing_test_and_teardown.sh"
}

function the_runner_call_teardown_if_test_exits() {
  _the_runner_call_teardown_if_test_fails_or_exits \
    "file_with_exiting_test_and_teardown.sh"
}

function _the_runner_call_teardown_if_test_fails_or_exits() {
	( configuration_load
	  SBU_TEST_FILE_PATTERN="*$1"
	  runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "failing_test_function" "${called_functions[0]}"
	assertion__equal "teardown" "${called_functions[1]}"
}

function _get_called_functions() {
	database_get "${_FUNCTIONS_DOCUMENT_KEY}"
}

function _function_called() {
  database_post "${_FUNCTIONS_DOCUMENT_KEY}" "$1 "
}