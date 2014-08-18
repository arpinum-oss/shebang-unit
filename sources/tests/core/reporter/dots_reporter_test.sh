function setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/reporter_test_helper.sh"
  helper__setup
}

function teardown() {
  helper__teardown
}

function can_report_tests_runs_without_failures() {
  helper__can_report_tests_runs_without_failures
}

function can_report_tests_runs_with_failures() {
  helper__can_report_tests_runs_with_failures
}

function can_report_tests_runs_with_tests_skipped() {
  helper__can_report_tests_runs_with_tests_skipped
}

function all_functions_are_overriden() {
  helper__all_functions_are_overriden
}

function _reporter() {
  printf "dots"
}