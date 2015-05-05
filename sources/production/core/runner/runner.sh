runner__run_all_test_files() {
  SBU_BASE_TEST_DIRECTORY=$1
  reporter__test_files_start_running
  timer__store_current_time "global_time"
  results__test_files_start_running
  _runner__run_all_test_files_with_pattern_in_directory "$1"
  reporter__test_files_end_running "$(timer__get_time_elapsed "global_time")"
  runner__tests_are_successful
}

_runner__run_all_test_files_with_pattern_in_directory() {
  local file
  local files
  array__from_lines files <<< "$(_runner__get_test_files_in_directory "$1")"
  for file in "${files[@]}"; do
    file_runner__run_test_file "${file}"
  done
}

_runner__get_test_files_in_directory() {
  local files
  array__from_lines files <<< "$(find "$1" -name "${SBU_TEST_FILE_PATTERN}" | sort)"
  if [[ "${SBU_RANDOM_RUN}" == "${SBU_YES}"  ]]; then
    array__from_lines files <<< "$(system__randomize_array "${files[@]}")"
  fi
  array__print "${files[@]}"
}

runner__tests_are_successful() {
  (( $(results__get_failing_tests_count) == 0 \
      && $(results__get_skipped_tests_count) == 0 ))
}
