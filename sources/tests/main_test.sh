function global_setup() {
  _TEST_DIR="${TESTS_RESOURCES_DIR}/directory_with_no_test"
	source "${SOURCES_DIR}/main.sh"
}

function setup() {
  _TEMP_FILE_FOR_VARIABLE_SHARING="/tmp/sbu.txt"
  touch "${_TEMP_FILE_FOR_VARIABLE_SHARING}"
}

function teardown() {
	rm -rf "${_TEMP_FILE_FOR_VARIABLE_SHARING}"
}

function can_enable_colors() {
	( SBU_USE_COLORS="${SBU_NO}"
	  main__main --colors="${SBU_YES}" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_USE_COLORS" )

  local variable="$(_import_variable "SBU_USE_COLORS")"
	assertion__equal "${SBU_YES}" "${variable}"
}

function can_enable_colors_with_short_option() {
	(	SBU_USE_COLORS="${SBU_NO}"
	  main__main -c="${SBU_YES}" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_USE_COLORS" )

  local variable="$(_import_variable "SBU_USE_COLORS")"
	assertion__equal "${SBU_YES}" "${variable}"
}

function can_disable_colors() {
	( SBU_USE_COLORS="${SBU_YES}"
	  main__main --colors="${SBU_NO}" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_USE_COLORS" )

  local variable="$(_import_variable "SBU_USE_COLORS")"
	assertion__equal "${SBU_NO}" "${variable}"
}

function can_use_a_test_file_pattern() {
	( SBU_TEST_FILE_PATTERN="anything"
	  main__main --pattern=*my_test.sh "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_TEST_FILE_PATTERN" )

  local variable="$(_import_variable "SBU_TEST_FILE_PATTERN")"
	assertion__equal "*my_test.sh" "${variable}"
}

function can_use_a_test_file_pattern_with_short_option() {
	( SBU_TEST_FILE_PATTERN="anything"
	  main__main -p=*my_test.sh "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_TEST_FILE_PATTERN" )

  local variable="$(_import_variable "SBU_TEST_FILE_PATTERN")"
	assertion__equal "*my_test.sh" "${variable}"
}

function can_define_one_reporter() {
	( SBU_REPORTERS="to_change"
	  main__main --reporters="dots" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_REPORTERS" )

  local variable="$(_import_variable "SBU_REPORTERS")"
	assertion__equal "dots" "${variable}"
}

#ignore
function _can_define_multiple_reporters() {
	( SBU_REPORTERS="to_change"
	  main__main --reporters="simple,dots" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_REPORTERS" )

  local variable="$(_import_variable "SBU_REPORTERS")"
	assertion__equal "simple,dots" "${variable}"
}

function can_define_reporters_with_short_option() {
	SBU_REPORTERS="to_change"

	( main__main -r="dots" "${_TEST_DIR}" > /dev/null
	  _export_variable "SBU_REPORTERS" )

  local variable="$(_import_variable "SBU_REPORTERS")"
	assertion__equal "dots" "${variable}"
}

function cannot_define_unkown_reporter() {
	local message

	message="$(main__main --reporters="unknown" "${_TEST_DIR}")"

  assertion__status_code_is_failure $?
  local expected="shebang_unit: unknown reporter <unknown>"
  assertion__equal "${expected}" "${message}"
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

function _export_variable() {
  printf "%s" "${!1}" > "${_TEMP_FILE_FOR_VARIABLE_SHARING}"
}

function _import_variable() {
  cat "${_TEMP_FILE_FOR_VARIABLE_SHARING}"
}