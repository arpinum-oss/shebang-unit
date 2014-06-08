function setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/reporter_test_helper.sh"
  helper_setup
}

function teardown() {
	helper_teardown
}

function can_report_tests_runs_without_failures() {
  helper_can_report_tests_runs_without_failures
}

function can_report_tests_runs_with_failures() {
  helper_can_report_tests_runs_with_failures
}

function can_report_tests_runs_with_tests_skipped() {
  helper_can_report_tests_runs_with_tests_skipped
}

function _reporter() {
  printf "dots"
}