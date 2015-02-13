reporter__test_files_start_running() {
  _reporter__initialise_file_descriptors
  reporter__for_each_reporter \
    _reporter__call_function "test_files_start_running" "$@"
}

_reporter__initialise_file_descriptors() {
  eval "exec ${SBU_STANDARD_FD}>&1"
  eval "exec ${SBU_ERROR_FD}>&2"
}

reporter__global_setup_has_failed() {
  reporter__for_each_reporter \
    _reporter__call_function "global_setup_has_failed" "$@"
}

reporter__test_file_starts_running() {
  reporter__for_each_reporter \
    _reporter__call_function "test_file_starts_running" "$@"
}

reporter__test_starts_running() {
  reporter__for_each_reporter \
    _reporter__call_function "test_starts_running" "$@"
}

reporter__test_has_succeeded() {
  reporter__for_each_reporter \
    _reporter__call_function "test_has_succeeded" "$@"
}

reporter__test_has_failed() {
  reporter__for_each_reporter \
    _reporter__call_function "test_has_failed" "$@"
}

reporter__test_is_skipped() {
  reporter__for_each_reporter \
    _reporter__call_function "test_is_skipped" "$@"
}

reporter__test_ends_running() {
  reporter__for_each_reporter \
    _reporter__call_function "test_ends_running" "$@"
}

reporter__test_file_ends_running() {
  reporter__for_each_reporter \
    _reporter__call_function "test_file_ends_running" "$@"
}

reporter__test_files_end_running() {
  reporter__for_each_reporter \
    _reporter__call_function "test_files_end_running" "$@"
  _reporter__release_file_descriptors
}

_reporter__release_file_descriptors() {
  eval "exec 1>&${SBU_STANDARD_FD} ${SBU_STANDARD_FD}>&-"
  eval "exec 2>&${SBU_ERROR_FD} ${SBU_ERROR_FD}>&-"
}

_reporter__call_function() {
  local function=$1
  shift 1
  "${reporter}_reporter__${function}" "$@"
}

reporter__for_each_reporter() {
  local reporter
  for reporter in ${SBU_REPORTERS//${SBU_VALUE_SEPARATOR}/ }; do
    "$@"
  done
}

reporter__print_with_color() {
  system__print_with_color "$@" >&${SBU_STANDARD_FD}
}

reporter__print_line() {
  system__print_line "$@" >&${SBU_STANDARD_FD}
}

reporter__print_line_with_color() {
  system__print_line_with_color "$@" >&${SBU_STANDARD_FD}
}

reporter__print_new_line() {
  system__print_new_line >&${SBU_STANDARD_FD}
}

reporter__get_color_code_for_tests_result() {
  local color_code=${SBU_GREEN_COLOR_CODE}
  if ! runner__tests_are_successful; then
    color_code=${SBU_RED_COLOR_CODE}
  fi
  system__print "${color_code}"
}

reporter__get_test_file_relative_name() {
  system__print "${1#${SBU_BASE_TEST_DIRECTORY}\/}"
}
