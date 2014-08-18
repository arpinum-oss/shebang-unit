function global_setup() {
  _RESOURCES="${TESTS_RESOURCES_DIR}/runner"
  helper__use_silent_reporter
}

function setup() {
  database__initialise
}

function teardown() {
  database__release
}

function if_no_test_results_are_0() {
  runner__run_all_test_files "${_RESOURCES}/directory_with_no_test"

  assertion__equal 0 "$(results__get_successful_tests_count)"
  assertion__equal 0 "$(results__get_failing_tests_count)"
  assertion__equal 0 "$(results__get_skipped_tests_count)"
  assertion__equal 0 "$(results__get_total_tests_count)"
}

function results_count_both_successful_and_failing_tests() {
  runner__run_all_test_files \
    "${_RESOURCES}/directory_with_3_successful_tests_and_2_failing_ones"

  assertion__equal 3 "$(results__get_successful_tests_count)"
  assertion__equal 2 "$(results__get_failing_tests_count)"
  assertion__equal 0 "$(results__get_skipped_tests_count)"
  assertion__equal 5 "$(results__get_total_tests_count)"
}

function a_test_with_a_failing_setup_is_failing() {
  SBU_TEST_FILE_PATTERN="file_with_failing_setup_and_2_tests.sh"

  runner__run_all_test_files "${_RESOURCES}/directory_for_failures_tests"

  assertion__equal 0 "$(results__get_successful_tests_count)"
  assertion__equal 2 "$(results__get_failing_tests_count)"
  assertion__equal 0 "$(results__get_skipped_tests_count)"
  assertion__equal 2 "$(results__get_total_tests_count)"
}

function a_test_with_a_failing_global_setup_is_skipped() {
  SBU_TEST_FILE_PATTERN="file_with_failing_global_setup_and_2_tests.sh"

  runner__run_all_test_files "${_RESOURCES}/directory_for_failures_tests"

  assertion__equal 0 "$(results__get_successful_tests_count)"
  assertion__equal 0 "$(results__get_failing_tests_count)"
  assertion__equal 2 "$(results__get_skipped_tests_count)"
  assertion__equal 2 "$(results__get_total_tests_count)"
}