function helper_global_setup() {
  _TEMP_FILE_FOR_TESTS_OUTPUT="/tmp/sbu.txt"
}

function helper_teardown() {
	rm -rf "${_TEMP_FILE_FOR_TESTS_OUTPUT}"
}

function helper_can_report_tests_runs_without_failures() {
  _run_all_tests_files "${TESTS_RESOURCES_DIR}/reporter/\
two_successful_tests"

  assertion__equal "$(cat "${_TEMP_FILE_FOR_TESTS_OUTPUT}")" \
                   "$(_get_expected_content \
                        "$(_reporter_to_test)_reporter_output")"
}

function helper_can_report_tests_runs_with_failures() {
  _run_all_tests_files "${TESTS_RESOURCES_DIR}/reporter/\
one_successful_test_and_one_failing"

  assertion__equal "$(cat "${_TEMP_FILE_FOR_TESTS_OUTPUT}")" \
                   "$(_get_expected_content \
                          "$(_reporter_to_test)_reporter_output_with_failures")"
}

function _run_all_tests_files() {
  local directory=$1
	( source "${SOURCES_DIR}/configuration.sh"
	  SBU_REPORTERS="$(_reporter_to_test)"
	  _stub_runner_to_return_1337s_for_exection_time
	  runner__run_all_test_files "${directory}" \
	    > "${_TEMP_FILE_FOR_TESTS_OUTPUT}" )
}

function _stub_runner_to_return_1337s_for_exection_time() {
  eval "function _runner__get_execution_time() { printf "1337"; }"
}

function _get_expected_content() {
  local expected_output_file="${TESTS_RESOURCES_DIR}/reporter/$1.txt"
  _evaluate "$(cat "${expected_output_file}")" \
                    "TESTS_RESOURCES_DIR" \
                    "${TESTS_RESOURCES_DIR}"
}

function _evaluate() {
    local string=$1
    local key="\$\{$2\}"
    local value=$3
    printf "%s" "${string//${key}/${value}}"
}