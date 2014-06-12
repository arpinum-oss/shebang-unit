function runner__run_all_test_files() {
   eval "_runner__do_run_all_test_files_and_redirect_test_outputs "$@" \
            ${SBU_REPORTERS_FD}>&1"
}

function _runner__do_run_all_test_files_and_redirect_test_outputs() {
  _runner__run_all_test_files "$@" 2>&1 | reporter__redirect_tests_outputs;
  return "${PIPESTATUS[0]}"
}

function _runner__run_all_test_files() {
	reporter__test_files_start_running
	timer__store_current_time "global_time"
	results__test_files_start_running
	_runner__run_all_test_files_with_pattern_in_directory "$1"
	reporter__test_files_end_running "$(timer__get_time_elapsed "global_time")"
	runner__tests_are_successful
}

function _runner__run_all_test_files_with_pattern_in_directory() {
	local file
	for file in $(find "$1" -name "${SBU_TEST_FILE_PATTERN}" | sort); do
		file_runner__run_test_file "${file}"
	done
}

function runner__tests_are_successful() {
	(( $(results__get_failing_tests_count) == 0 \
	    && $(results__get_skipped_tests_count) == 0 ))
}