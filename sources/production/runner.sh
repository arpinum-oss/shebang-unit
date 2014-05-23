function runner__run_all_test_files() {
	_runner__initialise_tests_execution
	_runner__run_all_test_files_with_pattern_in_directory "$1"
	_runner__print_tests_results
	_runner__tests_are_successful
}

function _runner__run_all_test_files_with_pattern_in_directory() {
	local file
	for file in $(find "$1" -name "${SBU_TEST_FILE_PATTERN}"); do
		file_runner__run_test_file "${file}"
	done
}

function _runner__initialise_tests_execution() {
	global_green_tests_count=0
	global_red_tests_count=0
	global_execution_begining_date="$(system__get_date_in_seconds)"
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