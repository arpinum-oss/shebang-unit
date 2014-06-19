function runner__run_all_test_files() {
	SBU_BASE_TEST_DIRECTORY=$1
	reporter__test_files_start_running
	timer__store_current_time "global_time"
	results__test_files_start_running
	_runner__run_all_test_files_with_pattern_in_directory "$1"
	reporter__test_files_end_running "$(timer__get_time_elapsed "global_time")"
	runner__tests_are_successful
}

function _runner__run_all_test_files_with_pattern_in_directory() {
	local file
	local files=($(_runner__get_test_files_in_directory "$1"))
	for file in "${files[@]}"; do
		file_runner__run_test_file "${file}"
	done
}

function _runner__get_test_files_in_directory() {
  local files=($(find "$1" -name "${SBU_TEST_FILE_PATTERN}" | sort))
  if [[ "${SBU_RANDOM_RUN}" == "${SBU_YES}"  ]]; then
    files=($(system__randomize_array "${files[@]}"))
  fi
  system__print_array "${files[@]}"
}

function runner__tests_are_successful() {
	(( $(results__get_failing_tests_count) == 0 \
	    && $(results__get_skipped_tests_count) == 0 ))
}