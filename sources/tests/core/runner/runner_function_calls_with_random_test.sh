function global_setup() {
  helper__use_silent_reporter
  SBU_RANDOM_RUN=${SBU_YES}
}

function setup() {
  database__initialise
}

function teardown() {
  database__release
}

function can_execute_test_files_randomly() {
  local tests_dir="${TESTS_RESOURCES_DIR}/runner/directory_with_a_lot_of_files"

  runner__run_all_test_files "${tests_dir}"

  local called_functions=($(helper__get_called_functions))
  assertion__equal 10 "${#called_functions[@]}"
  local ordered="[f_01, f_02, f_03, f_04, f_05, f_06, f_07, f_08, f_09, f_10]"
  local actual="$(system__pretty_print_array "${called_functions[@]}")"
  assertion__different "${ordered}" "${actual}"
}

function can_execute_test_functions_randomly() {
  local tests_dir="${TESTS_RESOURCES_DIR}/runner/directory_with_a_lot_of_functions"

  runner__run_all_test_files "${tests_dir}"

  local called_functions=($(helper__get_called_functions))
  assertion__equal 10 "${#called_functions[@]}"
  local ordered="[f_a, f_b, f_c, f_d, f_e, f_f, f_g, f_h, f_i, f_j]"
  local actual="$(system__pretty_print_array "${called_functions[@]}")"
  assertion__different "${ordered}" "${actual}"
}
