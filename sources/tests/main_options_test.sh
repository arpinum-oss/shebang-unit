function global_setup() {
  _TEST_DIR="not_used"
  _MAIN="main__main --no-run"
}

function can_enable_colors() {
	${_MAIN} --colors="${SBU_YES}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_enable_colors_with_short_option() {
	${_MAIN} -c="${SBU_YES}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_disable_colors() {
	${_MAIN} --colors="${SBU_NO}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_NO}" "${SBU_USE_COLORS}"
}

function can_use_a_test_file_pattern() {
	${_MAIN} --pattern=*my_test.sh "${_TEST_DIR}" > /dev/null

	assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function can_use_a_test_file_pattern_with_short_option() {
	${_MAIN} -p=*my_test.sh "${_TEST_DIR}" > /dev/null

  local variable="$(database__get "SBU_TEST_FILE_PATTERN")"
	assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function can_define_one_reporter() {
	${_MAIN} --reporters="dots" "${_TEST_DIR}" > /dev/null

	assertion__equal "dots" "${SBU_REPORTERS}"
}

function can_define_multiple_reporters() {
	${_MAIN} --reporters="simple,dots" "${_TEST_DIR}" > /dev/null

	assertion__equal "simple,dots" "${SBU_REPORTERS}"
}

function can_define_reporters_with_short_option() {
	${_MAIN} -r="dots" "${_TEST_DIR}" > /dev/null

	assertion__equal "dots" "${SBU_REPORTERS}"
}

function cannot_define_unkown_reporter() {
	local message

	message="$(${_MAIN} --reporters="unknown" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <unknown>"
  assertion__equal "${expected}" "${message}"
}

function unkown_reporter_is_printed_without_characters_evaluation() {
	local message

	message="$(${_MAIN} --reporters="%s" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <%s>"
  assertion__equal "${expected}" "${message}"
}

function cannot_define_known_and_unkown_reporter() {
	local message

	message="$(${_MAIN} --reporters="simple,unknown" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <unknown>"
  assertion__equal "${expected}" "${message}"
}

function cannot_use_unknown_option_with_value() {
  local message

  message="$(${_MAIN} --iks=plop "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
  assertion__string_contains "${message}" "usage:"
}

function unkown_option_is_printed_without_characters_evaluation() {
  local message

  message="$(${_MAIN} --%s=plop "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "shebang_unit: illegal option -- %s"
  assertion__string_contains "${message}" "usage:"
}

function can_define_reporter_output_file() {
	${_MAIN} --output-file="myfile.xml" "${_TEST_DIR}" > /dev/null

	assertion__equal "myfile.xml" "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

function cannot_use_unknown_option() {
  local message

  message="$(${_MAIN} --iks "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
}

function cannot_use_unknown_short_option_with_value() {
  local message

  message="$(${_MAIN} -x=plop "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

function cannot_use_unknown_short_option() {
  local message

  message="$(${_MAIN} -x "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

function can_print_full_usage_for_help_option() {
  local message

  message="$(${_MAIN} --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
}

function can_print_full_usage_for_help_short_option() {
  local message

  message="$(${_MAIN} -h)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
  assertion__string_contains "${message}" "[options]"
}

function cannot_use_more_than_one_argument_after_options() {
  local message

  message="$(${_MAIN} "${_TEST_DIR}" "an illegal second argument")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: only one path is allowed"
  assertion__string_contains "${message}" "${expected}"
  assertion__string_contains "${message}" "usage:"
}