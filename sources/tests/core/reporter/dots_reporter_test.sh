setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/reporter_test_helper.sh"
  helper__setup
}

teardown() {
  helper__teardown
}

can_report_tests_runs_without_failures() {
  helper__can_report_tests_runs_without_failures
}

can_report_tests_runs_with_failures() {
  helper__can_report_tests_runs_with_failures
}

can_report_tests_runs_with_tests_skipped() {
  helper__can_report_tests_runs_with_tests_skipped
}

all_functions_are_overriden() {
  helper__all_functions_are_overriden
}

_reporter() {
  printf "dots"
}
