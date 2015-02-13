setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/reporter_test_helper.sh"
  _override_get_output
  helper__setup
  SBU_JUNIT_REPORTER_OUTPUT_FILE="${SBU_TEMP_DIR}/junit_report.xml"
}

teardown() {
  if [[ -e "${SBU_JUNIT_REPORTER_OUTPUT_FILE}" ]]; then
    rm "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
  fi
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

_override_get_output() {
  mock__make_function_call "helper__get_output" "helper__get_output_overriden"
}

helper__get_output_overriden() {
  if [[ -e "${SBU_JUNIT_REPORTER_OUTPUT_FILE}" ]]; then
    cat "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
  fi
}

_reporter() {
  printf "junit"
}
