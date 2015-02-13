setup() {
  database__initialise
  results__test_files_start_running
  SBU_USE_COLOR=${SBU_NO}
  SBU_STANDARD_FD=1
  SBU_ERROR_FD=1
}

teardown() {
  database__release
}

prints_summary_with_singular_nouns_for_no_test() {
  local summary="$(simple_reporter__test_files_end_running)"

  assertion__string_contains "${summary}" "0 test, 0 failure, 0 skipped"
}

prints_summary_with_singular_nouns_for_1_test() {
  local summary="$(simple_reporter__test_files_end_running)"

  assertion__string_contains "${summary}" "0 test, 0 failure, 0 skipped"
}

prints_summary_with_plural_nouns_for_several_tests() {
  results__increment_successful_tests
  results__increment_successful_tests
  results__increment_successful_tests
  results__increment_failing_tests
  results__increment_failing_tests
  results__increment_failing_tests
  results__increment_failing_tests
  results__increment_skipped_tests
  results__increment_skipped_tests
  results__increment_skipped_tests

  local summary="$(simple_reporter__test_files_end_running)"

  assertion__string_contains "${summary}" "10 tests, 4 failures, 3 skipped"
}
