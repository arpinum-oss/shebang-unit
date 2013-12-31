_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS="/tmp/sbu.txt"

_TEST_RESOURCES_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")/../../resources/tests/directory_with_one_test"

function global_setup() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
	touch "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
	( runner::run_all_test_files_in_directory "${_TEST_RESOURCES_DIRECTORY}" > /dev/null )
	_called_functions=($(_get_called_functions))
}

function global_teardown() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

function the_runner_call_the_global_setup() {
	assertion::array_contains "global_setup" "${_called_functions[@]}"
}

function the_runner_call_the_global_teardown() {
	assertion::array_contains "global_teardown" "${_called_functions[@]}"
}

function the_runner_call_the_s3tup() {
	assertion::array_contains "setup" "${_called_functions[@]}"
}

function the_runner_call_the_t3ardown() {
	assertion::array_contains "teardown" "${_called_functions[@]}"
}

function the_runner_call_the_test_functions() {
	assertion::array_contains "first_test_function" "${_called_functions[@]}"
	assertion::array_contains "second_test_function" "${_called_functions[@]}"
}

function the_runner_call_functions_in_the_right_order() {
	assertion::equal "global_setup" "${_called_functions[0]}"
	assertion::equal "setup" "${_called_functions[1]}"
	assertion::equal "first_test_function" "${_called_functions[2]}"
	assertion::equal "teardown" "${_called_functions[3]}"
	assertion::equal "setup" "${_called_functions[4]}"
	assertion::equal "second_test_function" "${_called_functions[5]}"
	assertion::equal "teardown" "${_called_functions[6]}"
	assertion::equal "global_teardown" "${_called_functions[7]}"
	assertion::equal 8 "${#_called_functions[@]}"
}

function _get_called_functions() {
	cat "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

function _function_called() {
	printf "${1} " >> "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}