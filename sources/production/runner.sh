function runner::run_all_test_files_in_directory() {
	local directory=$1; local overriden_test_file_pattern=$2

	runner::_initialise_tests_execution
	local test_file_pattern="$(system::get_string_or_default_if_empty "${overriden_test_file_pattern}" "${SBU_DEFAULT_TEST_FILE_PATTERN}")"
	runner::_run_all_test_files_with_pattern_in_directory "${test_file_pattern}" "${directory}"
	runner::_print_tests_results
	runner::_tests_are_successful
}

function runner::_initialise_tests_execution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE="$(system::get_date_in_seconds)"
}

function runner::_run_all_test_files_with_pattern_in_directory() {
	local test_file_pattern=$1; local directory=$2

	local file; for file in $(find "${directory}" -name ${test_file_pattern}); do
		runner::_run_test_file "${file}"
	done
}

function runner::_run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	runner::_call_global_setup_in_file "${file}"
	runner::_call_all_tests_in_file "${file}"
	runner::_call_global_teardown_in_file "${file}"
	printf "\n"
}

function runner::_call_global_setup_in_file() {
	local file=$1
	runner::_call_function_if_existing "$(parser::find_global_setup_function_in_file "${file}")"
}

function runner::_call_global_teardown_in_file() {
	local file=$1
	runner::_call_function_if_existing "$(parser::find_global_teardown_function_in_file "${file}")"
}

function runner::_call_all_tests_in_file() {
	local file=$1
	local test_function; for test_function in $(parser::find_test_functions_in_file "${file}"); do
		runner::_call_test_function_in_the_middle_of_setup_and_teardown "${test_function}" "${file}"
	done
}

function runner::_call_test_function_in_the_middle_of_setup_and_teardown() {
	local test_function=$1; local file=$2

	printf "[Test] ${test_function}\n"
	( runner::_call_setup_in_file "${file}" &&
	( ${test_function} ) &&
	runner::_call_teardown_in_file "${file}" )
	runner::_parse_test_function_result "${test_function}" $?
}

function runner::_call_setup_in_file() {
	local file=$1
	runner::_call_function_if_existing "$(parser::find_setup_function_in_file "${file}")"
}

function runner::_call_teardown_in_file() {
	local file=$1
	runner::_call_function_if_existing "$(parser::find_teardown_function_in_file "${file}")"
}

function runner::_parse_test_function_result() {
	local test_function=$1; local status_code=$2

	if (( ${status_code} == ${SBU_SUCCESS_STATUS_CODE} )); then
		(( _GREEN_TESTS_COUNT++ ))
		runner::_print_with_color "OK" ${SBU_GREEN_COLOR_CODE}
	else
		(( _RED_TESTS_COUNT++ ))
		runner::_print_with_color "KO" ${SBU_RED_COLOR_CODE}
	fi
}

function runner::_print_tests_results() {
	printf "[Results]\n"
	local color="$(runner::_getColorCodeForTestsResult)"
	local execution_time="$(runner::_get_execution_time)"
	runner::_print_with_color "Green tests : ${_GREEN_TESTS_COUNT}, red : ${_RED_TESTS_COUNT} in ${execution_time}s" "${color}"
}

function runner::_getColorCodeForTestsResult() {
	local color_code=${SBU_GREEN_COLOR_CODE}
	if ! runner::_tests_are_successful; then
		color_code=${SBU_RED_COLOR_CODE}
	fi
	printf "${color_code}"
}

function runner::_get_execution_time() {
	local ending_date="$(system::get_date_in_seconds)"
	printf "$((${ending_date} - ${_EXECUTION_BEGINING_DATE}))"
}

function runner::_print_with_color() {
	local text=$1; local color_code=$2
	system::print_with_color "${text}" "${color_code}" "${SBU_DEFAULT_COLOR_CODE}"
}

function runner::_tests_are_successful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function runner::_call_function_if_existing() {
	local function=$1
	if [[ -n "${function}" ]]; then
		eval ${function}
	fi
}