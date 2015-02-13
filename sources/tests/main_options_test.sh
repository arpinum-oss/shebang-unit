global_setup() {
  _TEST_DIR="not_used"
  _MAIN="main__main --no-run"
}

can_enable_colors() {
  ${_MAIN} --colors="${SBU_YES}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

can_enable_colors_with_short_option() {
  ${_MAIN} -c="${SBU_YES}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

can_disable_colors() {
  ${_MAIN} --colors="${SBU_NO}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_NO}" "${SBU_USE_COLORS}"
}

can_enable_random_run() {
  ${_MAIN} --random-run="${SBU_YES}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_YES}" "${SBU_RANDOM_RUN}"
}

can_enable_random_run_with_short_option() {
  ${_MAIN} -d="${SBU_YES}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_YES}" "${SBU_RANDOM_RUN}"
}

can_disable_random_run() {
  ${_MAIN} --random-run="${SBU_NO}" "${_TEST_DIR}" > /dev/null

  assertion__equal "${SBU_NO}" "${SBU_RANDOM_RUN}"
}

can_use_a_test_file_pattern() {
  ${_MAIN} --file-pattern=*my_test.sh "${_TEST_DIR}" > /dev/null

  assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

can_use_a_test_file_pattern_with_short_option() {
  ${_MAIN} -f=*my_test.sh "${_TEST_DIR}" > /dev/null

  local variable="$(database__get "SBU_TEST_FILE_PATTERN")"
  assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

can_use_a_test_function_pattern() {
  ${_MAIN} --test-pattern=my_test* "${_TEST_DIR}" > /dev/null

  assertion__equal "my_test*" "${SBU_TEST_FUNCTION_PATTERN}"
}

can_use_a_test_function_pattern_with_short_option() {
  ${_MAIN} -t=my_test* "${_TEST_DIR}" > /dev/null

  local variable="$(database__get "SBU_TEST_FUNCTION_PATTERN")"
  assertion__equal "my_test*" "${SBU_TEST_FUNCTION_PATTERN}"
}

can_define_one_reporter() {
  ${_MAIN} --reporters="dots" "${_TEST_DIR}" > /dev/null

  assertion__equal "dots" "${SBU_REPORTERS}"
}

can_define_multiple_reporters() {
  ${_MAIN} --reporters="simple,dots" "${_TEST_DIR}" > /dev/null

  assertion__equal "simple,dots" "${SBU_REPORTERS}"
}

can_define_reporters_with_short_option() {
  ${_MAIN} -r="dots" "${_TEST_DIR}" > /dev/null

  assertion__equal "dots" "${SBU_REPORTERS}"
}

cannot_define_unkown_reporter() {
  local message

  message="$(${_MAIN} --reporters="unknown" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <unknown>"
  assertion__equal "${expected}" "${message}"
}

unkown_reporter_is_printed_without_characters_evaluation() {
  local message

  message="$(${_MAIN} --reporters="%s" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <%s>"
  assertion__equal "${expected}" "${message}"
}

cannot_define_known_and_unkown_reporter() {
  local message

  message="$(${_MAIN} --reporters="simple,unknown" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <unknown>"
  assertion__equal "${expected}" "${message}"
}

cannot_use_unknown_option_with_value() {
  local message

  message="$(${_MAIN} --iks=plop "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
  assertion__string_contains "${message}" "usage:"
}

unkown_option_is_printed_without_characters_evaluation() {
  local message

  message="$(${_MAIN} --%s=plop "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "shebang_unit: illegal option -- %s"
  assertion__string_contains "${message}" "usage:"
}

can_define_reporter_output_file() {
  ${_MAIN} --output-file="myfile.xml" "${_TEST_DIR}" > /dev/null

  assertion__equal "myfile.xml" "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

can_define_reporter_output_file_with_short_option() {
  ${_MAIN} -o="myfile.xml" "${_TEST_DIR}" > /dev/null

  assertion__equal "myfile.xml" "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

cannot_use_unknown_option() {
  local message

  message="$(${_MAIN} --iks "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
}

cannot_use_unknown_short_option_with_value() {
  local message

  message="$(${_MAIN} -x=plop "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

cannot_use_unknown_short_option() {
  local message

  message="$(${_MAIN} -x "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

can_print_full_usage_for_help_option() {
  local message

  message="$(${_MAIN} --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
}

can_print_full_usage_for_help_short_option() {
  local message

  message="$(${_MAIN} -h)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
  assertion__string_contains "${message}" "[options]"
}

cannot_use_more_than_one_argument_after_options() {
  local message

  message="$(${_MAIN} "${_TEST_DIR}" "an illegal second argument")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: only one path is allowed"
  assertion__string_contains "${message}" "${expected}"
  assertion__string_contains "${message}" "usage:"
}

can_print_api_cheat_sheet() {
  local message

  message="$(${_MAIN} --api-cheat-sheet)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "[assertions]"
  assertion__string_contains "${message}" "  assertion__equal"
  assertion__string_contains "${message}" "[special functions]"
  assertion__string_contains "${message}" "  ${SBU_GLOBAL_SETUP_FUNCTION_NAME}"
}
