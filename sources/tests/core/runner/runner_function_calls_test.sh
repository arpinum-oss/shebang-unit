_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS="/tmp/sbu.txt"
_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../../../production"
_TESTS_DIRECTORY="${_SOURCE_DIRECTORY}/../../../../resources/tests/\
directory_with_one_test"

function global_setup() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
	touch "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
	source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	( runner__run_all_test_files "${_TESTS_DIRECTORY}" > /dev/null )
	_called_functions=($(_get_called_functions))
}

function global_teardown() {
	rm -rf "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
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
	cat "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}

function _function_called() {
	printf "$1 " >> "${_TEMPORARY_FILE_TO_SHARE_VALUES_WITH_SUBSHELLS}"
}