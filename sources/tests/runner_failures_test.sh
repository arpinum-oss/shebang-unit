_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS="/tmp/sbu.txt"
_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../production"
_TESTS_DIRECTORY="${_SOURCE_DIRECTORY}/../../resources/tests/\
directory_for_failures_tests"

function setup() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
	touch "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

function teardown() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

#ignore
function _the_runner_calls_global_teardown_if_global_setup_fails() {
  source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*file_with_failing_global_setup.sh"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "global_setup" "${called_functions[0]}"
	assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_stops_file_execution_if_global_setup_exits() {
  source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*file_with_exiting_global_setup.sh"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

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
	source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*$1"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "failing_test_function" "${called_functions[0]}"
	assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_calls_teardown_if_setup_fails() {
  source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*file_with_failing_setup.sh"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "setup" "${called_functions[0]}"
	assertion__equal "teardown" "${called_functions[1]}"
}

function the_runner_stops_test_execution_if_setup_exists() {
  source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*file_with_exiting_setup.sh"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 1 "${#called_functions[@]}"
	assertion__equal "setup" "${called_functions[0]}"
}

function _the_runner_calls_teardown_if_setup_fails_or_exits() {
	source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*$1"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

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
	source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	SBU_TEST_FILE_PATTERN="*$1"

	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )

  assertion__status_code_is_failure $?
	local called_functions=($(_get_called_functions))
	assertion__equal 2 "${#called_functions[@]}"
	assertion__equal "failing_test_function" "${called_functions[0]}"
	assertion__equal "teardown" "${called_functions[1]}"
}

function _get_called_functions() {
	cat "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

function _function_called() {
	printf "$1 " >> "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}