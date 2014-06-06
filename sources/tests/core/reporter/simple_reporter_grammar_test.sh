function setup() {
	database__initialise
	results__tests_files_start_running
  SBU_USE_COLOR=${SBU_NO}
}

function teardown() {
  database__release
}

function prints_summary_with_singular_nouns_for_no_test() {
  local summary="$(simple_reporter__tests_files_end_running)"

  assertion__string_contains "${summary}" "0 test, 0 failure, 0 not run"
}

function prints_summary_with_singular_nouns_for_1_test() {
  local summary="$(simple_reporter__tests_files_end_running)"

  assertion__string_contains "${summary}" "0 test, 0 failure, 0 not run"
}

function prints_summary_with_plural_nouns_for_several_tests() {
  results__increment_by_n_total_tests_count 10
  results__increment_successful_tests
  results__increment_successful_tests
  results__increment_successful_tests
  results__increment_failing_tests
  results__increment_failing_tests
  results__increment_failing_tests
  results__increment_failing_tests

  local summary="$(simple_reporter__tests_files_end_running)"

  assertion__string_contains "${summary}" "10 tests, 4 failures, 3 not run"
}