global_setup() {
  _TESTS_DIR="${TESTS_RESOURCES_DIR}/runner/one_poorly_formated_test"
  helper__use_silent_reporter
}

setup() {
  database__initialise
}

teardown() {
  database__release
}

the_runner_call_the_test_functions() {
  runner__run_all_test_files "${_TESTS_DIR}"

  local called_functions=($(helper__get_called_functions))
  assertion__equal 7 "${#called_functions[@]}"
  assertion__equal "posix_function" "${called_functions[0]}"
  assertion__equal "posix_function_with_space_before_parenthesis" "${called_functions[1]}"
  assertion__equal "indented_posix_function" "${called_functions[2]}"
  assertion__equal "ksh_function" "${called_functions[3]}"
  assertion__equal "ksh_function_without_brace" "${called_functions[4]}"
  assertion__equal "ksh_function_with_space_before_parenthesis" "${called_functions[5]}"
  assertion__equal "ksh_posix_function" "${called_functions[6]}"
}
