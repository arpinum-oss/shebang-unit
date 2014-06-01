function runner__run_all_test_files() {
   eval "_runner__do_run_all_test_files_and_redirect_test_outputs "$@" \
            ${SBU_REPORTERS_FD}>&1"
}

function _runner__do_run_all_test_files_and_redirect_test_outputs() {
  _runner__run_all_test_files "$@" 2>&1 | reporter__redirect_tests_outputs;
  return "${PIPESTATUS[0]}"
}

function _runner__run_all_test_files() {
	_runner__initialise_tests_execution
	_runner__run_all_test_files_with_pattern_in_directory "$1"
	reporter__tests_files_end_running "$(_runner__get_execution_time)"
	runner__tests_are_successful
}

function _runner__run_all_test_files_with_pattern_in_directory() {
	local file
	for file in $(find "$1" -name "${SBU_TEST_FILE_PATTERN}" | sort); do
		file_runner__run_test_file "${file}"
	done
}

function _runner__initialise_tests_execution() {
	global_green_tests_count=0
	global_red_tests_count=0
	global_execution_begining_date="$(system__get_date_in_seconds)"
}

function _runner__get_execution_time() {
	local ending_date="$(system__get_date_in_seconds)"
	printf "$((${ending_date} - ${global_execution_begining_date}))"
}

function runner__tests_are_successful() {
	(( ${global_red_tests_count} == 0 ))
}