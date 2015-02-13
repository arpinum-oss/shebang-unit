file_runner__run_test_file() {
  local file=$1
  local public_functions=($(parser__get_public_functions_in_file "${file}"))
  local test_functions=($(_file_runner__get_test_functions))
  reporter__test_file_starts_running "${file}" "${#test_functions[@]}"
  ( source "${file}"
    _file_runner__run_global_setup_if_exists \
      && _file_runner__call_all_tests
    _file_runner__run_global_teardown_if_exists )
  _file_runner__check_if_global_setup_has_exited
  reporter__test_file_ends_running
}

_file_runner__run_all_tests_if_global_setup_is_successful() {
    _file_runner__call_all_tests
}

_file_runner__call_all_tests() {
  local i
  for (( i=0; i < ${#test_functions[@]}; i++ )); do
    test_runner__run_test "${test_functions[${i}]}" "${public_functions[@]}"
  done
}

_file_runner__skip_all_tests() {
  local i
  for (( i=0; i < ${#test_functions[@]}; i++ )); do
    test_runner__skip_test "${test_functions[${i}]}" "${public_functions[@]}"
  done
}

_file_runner__get_test_functions() {
  local result=()
  local test_function
  for test_function in "${public_functions[@]}"; do
    if _file_runner__function_is_a_test "${test_function}"\
       && [[ "${test_function}" == ${SBU_TEST_FUNCTION_PATTERN} ]]; then
      result+=("${test_function}")
    fi
  done
  _file_runner__get_randomized_test_functions_if_needed "${result[@]}"
}

_file_runner__get_randomized_test_functions_if_needed() {
  if [[ "${SBU_RANDOM_RUN}" == "${SBU_YES}" ]]; then
    system__randomize_array "$@"
  else
    system__print_array "$@"
  fi
}

_file_runner__run_global_setup_if_exists() {
  database__put "sbu_current_global_setup_has_failed" "${SBU_YES}"
  _file_runner__call_function_if_exists "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
    && database__put "sbu_current_global_setup_has_failed" "${SBU_NO}"
}

_file_runner__run_global_teardown_if_exists() {
  _file_runner__call_function_if_exists "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}"
}

_file_runner__function_is_a_test() {
  ! system__array_contains "$1" \
                      "${SBU_GLOBAL_SETUP_FUNCTION_NAME}" \
                      "${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}" \
                      "${SBU_SETUP_FUNCTION_NAME}" \
                      "${SBU_TEARDOWN_FUNCTION_NAME}"
}

_file_runner__call_function_if_exists() {
  local function=$1
  shift 1
  if system__array_contains "${function}" "${public_functions[@]}"; then
    "${function}"
  fi
}

_file_runner__check_if_global_setup_has_exited() {
  local has_exited="$(database__get "sbu_current_global_setup_has_failed")"
  if [[ "${has_exited}" == "${SBU_YES}" ]]; then
    _file_runner__handle_failure_in_global_setup
  fi
}

_file_runner__handle_failure_in_global_setup() {
    reporter__global_setup_has_failed
    _file_runner__skip_all_tests
}
