_GREEN_COLOR_CODE="\\033[1;32m"
_RED_COLOR_CODE="\\033[1;31m"
_DEFAULT_COLOR_CODE="\\e[0m"

_DEFAULT_TEST_FILE_PATTERN=*_test.sh

function runner::run_all_test_files_in_directory() {
	local directory=$1; local overriden_test_file_pattern=$2

	runner::_initialise_tests_execution
	local test_file_pattern="$(system::get_string_or_default_if_empty "${overriden_test_file_pattern}" "${_DEFAULT_TEST_FILE_PATTERN}")"
	_run_all_test_files_with_pattern_in_directory "${test_file_pattern}" "${directory}"
	_print_tests_results
	_tests_are_successful
}

function runner::_initialise_tests_execution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE="$(system::get_date_in_seconds)"
}

function _run_all_test_files_with_pattern_in_directory() {
	local test_file_pattern=$1; local directory=$2

	local file; for file in $(find "${directory}" -name ${test_file_pattern}); do
		_run_test_file "${file}"
	done
}

function _run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	_call_global_setup_in_file "${file}"
	_call_all_tests_in_file "${file}"
	_call_global_teardown_in_file "${file}"
	printf "\n"
}

function _call_global_setup_in_file() {
	local file=$1
	_call_function_if_existing "$(parser::find_global_setup_function_in_file "${file}")"
}

function _call_global_teardown_in_file() {
	local file=$1
	_call_function_if_existing "$(parser::find_global_teardown_function_in_file "${file}")"
}

function _call_all_tests_in_file() {
	local file=$1
	local test_function; for test_function in $(parser::find_test_functions_in_file "${file}"); do
		_call_test_function_in_the_middle_of_setup_and_teardown "${test_function}" "${file}"
	done
}

function _call_test_function_in_the_middle_of_setup_and_teardown() {
	local test_function=$1; local file=$2

	printf "[Test] ${test_function}\n"
	( _call_setup_in_file "${file}" &&
	( ${test_function} ) &&
	_call_teardown_in_file "${file}" )
	_parse_test_function_result "${test_function}" $?
}

function _call_setup_in_file() {
	local file=$1
	_call_function_if_existing "$(parser::find_setup_function_in_file "${file}")"
}

function _call_teardown_in_file() {
	local file=$1
	_call_function_if_existing "$(parser::find_teardown_function_in_file "${file}")"
}

function _parse_test_function_result() {
	local test_function=$1; local status_code=$2

	if (( ${status_code} == ${SUCCESS_STATUS_CODE} )); then
		(( _GREEN_TESTS_COUNT++ ))
		_print_with_color "OK" ${_GREEN_COLOR_CODE}
	else
		(( _RED_TESTS_COUNT++ ))
		_print_with_color "KO" ${_RED_COLOR_CODE}
	fi
}

function _print_tests_results() {
	printf "[Results]\n"
	local color="$(_getColorCodeForTestsResult)"
	local execution_time="$(_getExecutionTime)"
	_print_with_color "Green tests : ${_GREEN_TESTS_COUNT}, red : ${_RED_TESTS_COUNT} in ${execution_time}s" "${color}"
}

function _getColorCodeForTestsResult() {
	local color_code=${_GREEN_COLOR_CODE}
	if ! _tests_are_successful; then
		color_code=${_RED_COLOR_CODE}
	fi
	printf "${color_code}"
}

function _getExecutionTime() {
	local ending_date="$(system::get_date_in_seconds)"
	printf "$((${ending_date} - ${_EXECUTION_BEGINING_DATE}))"
}

function _print_with_color() {
	local text=$1; local color_code=$2
	system::print_with_color "${text}" "${color_code}" "${_DEFAULT_COLOR_CODE}"
}

function _tests_are_successful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function _call_function_if_existing() {
	local function=$1
	if [[ -n "${function}" ]]; then
		eval ${function}
	fi
}