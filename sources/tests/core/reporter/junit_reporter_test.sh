function setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/reporter_test_helper.sh"
  source "${TEST_SOURCES_DIR}/tests_utils/mock.sh"
  _override_get_output
  helper__setup
  SBU_JUNIT_REPORTER_OUTPUT_FILE="${SBU_TEMP_DIR}/junit_report.xml"
}

function teardown() {
  if [[ -e "${SBU_JUNIT_REPORTER_OUTPUT_FILE}" ]]; then
    rm "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
  fi
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

function _override_get_output() {
  mock__make_function_call "helper__get_output" "helper__get_output_overriden"
}

function helper__get_output_overriden() {
  if [[ -e "${SBU_JUNIT_REPORTER_OUTPUT_FILE}" ]]; then
    cat "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
  fi
}

function _reporter() {
  printf "junit"
}