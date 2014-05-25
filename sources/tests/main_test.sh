function global_setup() {
  _TEST_DIR="${TESTS_RESOURCES_DIR}/directory_with_no_test"
	source "${SOURCES_DIR}/main.sh"
}

function can_enable_colors() {
	SBU_USE_COLORS="${SBU_NO}"

	main__main --colors="${SBU_YES}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_enable_colors_with_short_option() {
	SBU_USE_COLORS="${SBU_NO}"

	main__main -c="${SBU_YES}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_YES}" "${SBU_USE_COLORS}"
}

function can_disable_colors() {
	SBU_USE_COLORS="${SBU_YES}"

	main__main --colors="${SBU_NO}" "${_TEST_DIR}" > /dev/null

	assertion__equal "${SBU_NO}" "${SBU_USE_COLORS}"
}

function can_use_a_test_file_pattern() {
	SBU_TEST_FILE_PATTERN="anything"

	main__main --pattern=*my_test.sh "${_TEST_DIR}" > /dev/null

	assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function can_use_a_test_file_pattern_with_short_option() {
	SBU_TEST_FILE_PATTERN="anything"

	main__main -p=*my_test.sh "${_TEST_DIR}" > /dev/null

	assertion__equal "*my_test.sh" "${SBU_TEST_FILE_PATTERN}"
}

function cannot_use_unknown_option_with_value() {
  local message

  message="$(main__main --iks=plop "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
  assertion__string_contains "${message}" "usage:"
}

function cannot_use_unknown_option() {
  local message

  message="$(main__main --iks "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- iks"
}

function cannot_use_unknown_short_option_with_value() {
  local message

  message="$(main__main -x=plop "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

function cannot_use_unknown_short_option() {
  local message

  message="$(main__main -x "${_TEST_DIR}")"

  assertion__string_contains "${message}" "shebang_unit: illegal option -- x"
}

function can_print_full_usage_for_help_option() {
  local message

  message="$(main__main --help)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
}

function can_print_full_usage_for_help_short_option() {
  local message

  message="$(main__main -h)"

  assertion__status_code_is_success $?
  assertion__string_contains "${message}" "usage:"
  assertion__string_contains "${message}" "[options]"
}

function cannot_use_more_than_one_argument_after_options() {
  local message

  message="$(main__main "${_TEST_DIR}" "an illegal second argument")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: only one path is allowed"
  assertion__string_contains "${message}" "${expected}"
  assertion__string_contains "${message}" "usage:"
}