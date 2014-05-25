function global_setup() {
  _TEMP_FILE_FOR_TESTS_OUTPUT="/tmp/sbu.txt"
  _TEST_DIR="${TESTS_RESOURCES_DIR}/directory_with_two_tests"

	( source "${SOURCES_DIR}/configuration.sh"
	  SBU_REPORTERS="dots"
	  _stub_runner_to_return_1337s_for_exection_time
	  runner__run_all_test_files "${_TEST_DIR}" \
	    > "${_TEMP_FILE_FOR_TESTS_OUTPUT}" )
}

function _stub_runner_to_return_1337s_for_exection_time() {
  eval "function _runner__get_execution_time() { printf "1337"; }"
}

function global_teardown() {
	rm -rf "${_TEMP_FILE_FOR_TESTS_OUTPUT}"
}

function can_report_tests_runs() {
  local expected_output_file="${TESTS_RESOURCES_DIR}/reporter/\
dots_reporter_output_with_failures.txt"

  assertion__equal "$(cat "${_TEMP_FILE_FOR_TESTS_OUTPUT}")" \
                   "$(cat "${expected_output_file}")"
}