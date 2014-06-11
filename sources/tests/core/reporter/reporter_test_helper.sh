function helper__setup() {
  _OUTPUT_DOCUMENT_KEY="reporter_output"
  _TESTS_DIR="${TESTS_RESOURCES_DIR}/reporter/tests"
  _OUTPUTS_DIR="${TESTS_RESOURCES_DIR}/reporter/outputs/$(_reporter)"
  reporter__initialise
}

function helper__teardown() {
  reporter__release
}

function helper__can_report_tests_runs_without_failures() {
  _run_all_test_files "${_TESTS_DIR}/two_successful_tests"

  local content="$(_reporter)_reporter_output"
  assertion__equal "$(_get_expected_content "${content}")" \
                   "$(helper__get_output)"
}

function helper__can_report_tests_runs_with_failures() {
  _run_all_test_files "${_TESTS_DIR}/one_successful_test_and_one_failing"

  local content="$(_reporter)_reporter_output_with_failures"
  assertion__equal "$(_get_expected_content "${content}")" \
                   "$(helper__get_output)"
}

function helper__can_report_tests_runs_with_tests_skipped() {
  _run_all_test_files "${_TESTS_DIR}/one_successful_test_and_one_skipped"

  local content="$(_reporter)_reporter_output_with_test_skipped"
  assertion__equal "$(_get_expected_content "${content}")" \
                   "$(helper__get_output)"
}

function helper__get_output() {
  database__get "${_OUTPUT_DOCUMENT_KEY}"
}

function _run_all_test_files() {
  local directory=$1
  SBU_REPORTERS="$(_reporter)"
  _stub_results_to_return_1337s_for_run_time
  database__put "${_OUTPUT_DOCUMENT_KEY}" \
    "$(runner__run_all_test_files "${directory}")"
}

function _stub_results_to_return_1337s_for_run_time() {
  eval "function results__get_run_time() { printf "1337"; }"
}

function _get_expected_content() {
  local expected_output_file="${_OUTPUTS_DIR}/$1.txt"
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

function helper__all_functions_are_overriden() {
  _assert_function_declared "test_files_start_running"
  _assert_function_declared "global_setup_has_failed"
  _assert_function_declared "test_file_starts_running"
  _assert_function_declared "test_starts_running"
  _assert_function_declared "test_has_succeeded"
  _assert_function_declared "test_has_failed"
  _assert_function_declared "test_is_skipped"
  _assert_function_declared "redirect_test_output"
  _assert_function_declared "test_ends_running"
  _assert_function_declared "test_file_ends_running"
  _assert_function_declared "test_files_end_running"
}

function _assert_function_declared() {
  local function="$(_reporter)_reporter__$1"
  type -t "${function}" > /dev/null
  assertion__status_code_is_success $? \
    "Function <${function}> should be declared."
}