function global_setup() {
  _TESTS_DIR="${TESTS_RESOURCES_DIR}/runner/one_poorly_formated_test"
  helper__use_silent_reporter
}

function setup() {
  database__initialise
}

function teardown() {
  database__release
}

function the_runner_call_the_test_functions() {
  runner__run_all_test_files "${_TESTS_DIR}"

  local called_functions=($(helper__get_called_functions))
  assertion__equal 3 "${#called_functions[@]}"
  assertion__equal "well_formated_test_function" "${called_functions[0]}"
  assertion__equal "indented_test_function" "${called_functions[1]}"
  assertion__equal "inlined_test_function" "${called_functions[2]}"
}