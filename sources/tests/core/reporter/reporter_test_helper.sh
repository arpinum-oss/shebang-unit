function helper_setup() {
  _OUTPUT_DOCUMENT_KEY="reporter_output"
  database_initialise
}

function helper_teardown() {
	database_destroy
}

function helper_can_report_tests_runs_without_failures() {
  _run_all_tests_files "${TESTS_RESOURCES_DIR}/reporter/\
two_successful_tests"

  local content="$(_reporter)_reporter_output"
  assertion__equal "$(_get_expected_content "${content}")" \
                   "$(database_get "${_OUTPUT_DOCUMENT_KEY}")"
}

function helper_can_report_tests_runs_with_failures() {
  _run_all_tests_files "${TESTS_RESOURCES_DIR}/reporter/\
one_successful_test_and_one_failing"

  local content="$(_reporter)_reporter_output_with_failures"
  assertion__equal "$(_get_expected_content "${content}")" \
                   "$(database_get "${_OUTPUT_DOCUMENT_KEY}")"
}

function _run_all_tests_files() {
  local directory=$1
	( configuration_load
	  SBU_REPORTERS="$(_reporter)"
	  _stub_runner_to_return_1337s_for_exection_time
	  database_put "${_OUTPUT_DOCUMENT_KEY}" \
	    "$(runner__run_all_test_files "${directory}")" )
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