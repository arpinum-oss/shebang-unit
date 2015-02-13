simple_reporter__test_files_start_running() {
  :
}

simple_reporter__test_file_starts_running() {
  local relative_name="$(reporter__get_test_file_relative_name "$1")"
  reporter__print_line "[File] ${relative_name}"
}

simple_reporter__global_setup_has_failed() {
  reporter__print_line_with_color \
    "Global setup has failed" ${SBU_YELLOW_COLOR_CODE}
}

simple_reporter__test_starts_running() {
  reporter__print_line "[Test] $1"
}

simple_reporter__test_has_succeeded() {
  reporter__print_line_with_color "OK" ${SBU_GREEN_COLOR_CODE}
}

simple_reporter__test_has_failed() {
  reporter__print_line_with_color "KO" ${SBU_RED_COLOR_CODE}
}

simple_reporter__test_is_skipped() {
  reporter__print_line_with_color "Skipped" ${SBU_YELLOW_COLOR_CODE}
}

simple_reporter__test_ends_running() {
  :
}

simple_reporter__test_file_ends_running() {
  reporter__print_new_line
}

simple_reporter__test_files_end_running() {
  local time="in $1s"
  reporter__print_line "[Results]"
  local color="$(reporter__get_color_code_for_tests_result)"
  local total_count="$(_simple_reporter__get_total_count_message)"
  local failures_count="$(_simple_reporter__get_failures_count_message)"
  local skipped_count="$(results__get_skipped_tests_count) skipped"
  local message="${total_count}, ${failures_count}, ${skipped_count} ${time}"
  reporter__print_line_with_color "${message}" "${color}"
}

_simple_reporter__get_total_count_message() {
  local count="$(results__get_total_tests_count)"
  system__print "${count} test$(_simple_reporter__get_agreement ${count})"
}

_simple_reporter__get_failures_count_message() {
  local count="$(results__get_failing_tests_count)"
  system__print "${count} failure$(_simple_reporter__get_agreement ${count})"
}

_simple_reporter__get_agreement() {
  (( $1 > 1 )) \
    && system__print "s" \
    || system__print ""
}
