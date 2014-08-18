function global_setup() {
  _TESTS_DIR="${TESTS_RESOURCES_DIR}/runner/directory_for_failures_tests"
  helper__use_silent_reporter
}

function setup() {
  database__initialise
}

function teardown() {
  database__release
}

function the_runner_calls_global_teardown_if_global_setup_fails() {
  SBU_TEST_FILE_PATTERN="*file_with_failing_global_setup.sh"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#called_functions[@]}"
  assertion__equal "global_setup" "${called_functions[0]}"
  assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_stops_file_run_if_global_setup_exits() {
  SBU_TEST_FILE_PATTERN="*file_with_exiting_global_setup.sh"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 1 "${#called_functions[@]}"
  assertion__equal "global_setup" "${called_functions[0]}"
}

function the_runner_calls_global_teardown_if_test_fails() {
  _the_runner_calls_global_teardown_if_test_fails_or_exits \
    "file_with_failing_test.sh"
}

function the_runner_calls_global_teardown_if_test_exits() {
  _the_runner_calls_global_teardown_if_test_fails_or_exits \
    "file_with_exiting_test.sh"
}

function _the_runner_calls_global_teardown_if_test_fails_or_exits() {
  SBU_TEST_FILE_PATTERN="*$1"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#called_functions[@]}"
  assertion__equal "failing_test_function" "${called_functions[0]}"
  assertion__equal "global_teardown" "${called_functions[1]}"
}

function the_runner_calls_teardown_if_setup_fails() {
  SBU_TEST_FILE_PATTERN="*file_with_failing_setup.sh"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#called_functions[@]}"
  assertion__equal "setup" "${called_functions[0]}"
  assertion__equal "teardown" "${called_functions[1]}"
}

function the_runner_stops_test_run_if_setup_exists() {
  SBU_TEST_FILE_PATTERN="*file_with_exiting_setup.sh"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 1 "${#called_functions[@]}"
  assertion__equal "setup" "${called_functions[0]}"
}

function _the_runner_calls_teardown_if_setup_fails_or_exits() {
  SBU_TEST_FILE_PATTERN="*$1"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#called_functions[@]}"
  assertion__equal "setup" "${called_functions[0]}"
  assertion__equal "teardown" "${called_functions[1]}"
}

function the_runner_call_teardown_if_test_fails() {
  _the_runner_call_teardown_if_test_fails_or_exits \
    "file_with_failing_test_and_teardown.sh"
}

function the_runner_call_teardown_if_test_exits() {
  _the_runner_call_teardown_if_test_fails_or_exits \
    "file_with_exiting_test_and_teardown.sh"
}

function _the_runner_call_teardown_if_test_fails_or_exits() {
  SBU_TEST_FILE_PATTERN="*$1"

  runner__run_all_test_files "${_TESTS_DIR}"

  assertion__status_code_is_failure $?
  local called_functions=($(helper__get_called_functions))
  assertion__equal 2 "${#called_functions[@]}"
  assertion__equal "failing_test_function" "${called_functions[0]}"
  assertion__equal "teardown" "${called_functions[1]}"
}