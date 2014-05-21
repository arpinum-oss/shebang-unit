function runner__run_all_test_files() {
	_runner__initialise_tests_execution
	_runner__run_all_test_files_with_pattern_in_directory "$1"
	_runner__print_tests_results
	_runner__tests_are_successful
}

function _runner__initialise_tests_execution() {
	global_green_tests_count=0
	global_red_tests_count=0
	global_execution_begining_date="$(system__get_date_in_seconds)"
}

function _runner__run_all_test_files_with_pattern_in_directory() {
	local file
	for file in $(find "$1" -name "${SBU_TEST_FILE_PATTERN}"); do
		_runner__run_test_file "${file}"
	done
}

function _runner__run_test_file() {
	local file=$1
	printf "[File] ${file}\n"
	source "${file}"
	local public_functions=($(parser__get_public_functions_in_file "${file}"))
	_runner__call_function_if_in_array "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
		"${public_functions[@]}"
	_runner__call_all_tests "${public_functions[@]}"
	_runner__call_function_if_in_array "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
		"${public_functions[@]}"
	printf "\n"
}

function _runner__call_all_tests() {
	local i
	for (( i=1; i <= $#; i++ )); do
		_runner__call_if_test_function "${!i}" "$@"
	done
}

function _runner__call_if_test_function() {
	local function=$1
	shift 1
	if _runner__function_is_a_test "${function}"; then
		_runner__call_test_function_in_the_middle_of_setup_and_teardown \
			"${function}" "$@"
	fi
}

function _runner__function_is_a_test() {
	! system__array_contains "$1" \
	                    "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
	                    "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
	                    "${SBU_SETUP_FUNCTION_NAME}" \
	                    "${SBU_TEARDOWN_FUNCTION_NAME}"
}

function _runner__call_test_function_in_the_middle_of_setup_and_teardown() {
	local test_function=$1
	shift 1

	printf "[Test] ${test_function}\n"
	(
	  _runner__call_function_if_in_array "${SBU_SETUP_FUNCTION_NAME}" "$@" \
	  && ( ${test_function} )
	  local setup_and_test_result=$?
	  _runner__call_function_if_in_array "${SBU_TEARDOWN_FUNCTION_NAME}" "$@"
	  (( ${setup_and_test_result} == ${SBU_SUCCESS_STATUS_CODE} \
	  && $? == ${SBU_SUCCESS_STATUS_CODE}  ))
	)
	_runner__parse_test_function_result $?
}

function _runner__parse_test_function_result() {
	if (( $1 == ${SBU_SUCCESS_STATUS_CODE} )); then
		(( global_green_tests_count++ ))
		_runner__print_with_color "OK" ${SBU_GREEN_COLOR_CODE}
	else
		(( global_red_tests_count++ ))
		_runner__print_with_color "KO" ${SBU_RED_COLOR_CODE}
	fi
}

function _runner__print_tests_results() {
	printf "[Results]\n"
	local color="$(_runner__get_color_code_for_tests_result)"
	local execution_time="$(_runner__get_execution_time)"
	local green_tests="Green tests: ${global_green_tests_count}"
	local red_tests="red: ${global_red_tests_count}"
	local time="in ${execution_time}s"
	_runner__print_with_color "${green_tests}, ${red_tests} ${time}" "${color}"
}

function _runner__get_color_code_for_tests_result() {
	local color_code=${SBU_GREEN_COLOR_CODE}
	if ! _runner__tests_are_successful; then
		color_code=${SBU_RED_COLOR_CODE}
	fi
	printf "${color_code}"
}

function _runner__get_execution_time() {
	local ending_date="$(system__get_date_in_seconds)"
	printf "$((${ending_date} - ${global_execution_begining_date}))"
}

function _runner__print_with_color() {
	system__print_with_color "$1" "$2" "${SBU_DEFAULT_COLOR_CODE}"
}

function _runner__tests_are_successful() {
	(( ${global_red_tests_count} == 0 ))
}

function _runner__call_function_if_in_array() {
	local function=$1
	shift 1
	if system__array_contains "${function}" "$@"; then
	  "${function}"
	fi
}