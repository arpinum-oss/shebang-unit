function runner::run_all_test_files_in_directory() {
	runner::_initialise_tests_execution
	local test_file_pattern="$(system::get_string_or_default_if_empty "$2" "${SBU_DEFAULT_TEST_FILE_PATTERN}")"
	runner::_run_all_test_files_with_pattern_in_directory "${test_file_pattern}" "$1"
	runner::_print_tests_results
	runner::_tests_are_successful
}

function runner::_initialise_tests_execution() {
	_GREEN_TESTS_COUNT=0
	_RED_TESTS_COUNT=0
	_EXECUTION_BEGINING_DATE="$(system::get_date_in_seconds)"
}

function runner::_run_all_test_files_with_pattern_in_directory() {
	local file
	for file in $(find "$2" -name $1); do
		runner::_run_test_file "${file}"
	done
}

function runner::_run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	local public_functions=($(parser::get_public_functions_in_file "${file}"))
	runner::_call_function_if_existing_in_array "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" "${public_functions[@]}"
	runner::_call_all_tests "${public_functions[@]}"
	runner::_call_function_if_existing_in_array "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" "${public_functions[@]}"
	printf "\n"
}

function runner::_call_all_tests() {
	local i
	for (( i=1; i <= $#; i++ )); do
		local function="${!i}"
		if runner::_function_is_a_test "${function}"; then
			runner::_call_test_function_in_the_middle_of_setup_and_teardown "${function}" "${@}"
		fi
	done
}

function runner::_function_is_a_test() {
	local special_functions=("${SBU_GLOBAL_SETUP_FUNCTION_NAME}"
							 "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}"
							 "${SBU_SETUP_FUNCTION_NAME}"
							 "${SBU_TEARDOWN_FUNCTION_NAME}")
	! system::array_contains "${1}" "${special_functions[@]}"
}

function runner::_call_test_function_in_the_middle_of_setup_and_teardown() {
	local test_function=$1
	shift 1

	printf "[Test] ${test_function}\n"
	( runner::_call_function_if_existing_in_array "${SBU_SETUP_FUNCTION_NAME}" "$@" &&
	( ${test_function} ) &&
	runner::_call_function_if_existing_in_array "${SBU_TEARDOWN_FUNCTION_NAME}" "$@" )
	runner::_parse_test_function_result $?
}

function runner::_parse_test_function_result() {
	if (( $1 == ${SBU_SUCCESS_STATUS_CODE} )); then
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
	runner::_print_with_color "Green tests: ${_GREEN_TESTS_COUNT}, red: ${_RED_TESTS_COUNT} in ${execution_time}s" "${color}"
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
	system::print_with_color "$1" "$2" "${SBU_DEFAULT_COLOR_CODE}"
}

function runner::_tests_are_successful() {
	(( ${_RED_TESTS_COUNT} == 0 ))
}

function runner::_call_function_if_existing_in_array() {
	local function=$1
	shift 1
	if system::array_contains "${function}" "$@"; then
		eval ${function}
	fi
}