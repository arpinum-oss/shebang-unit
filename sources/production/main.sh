function main__main() {
	configuration__load
	_main__initialise
  local parsed_arguments=0
  _main__parse_arguments "$@"
  shift ${parsed_arguments}
  _main__assert_only_one_argument_left $#
	_main__assert_reporters_are_known
	SBU_BASE_TEST_DIRECTORY=$1

	if [[ "${SBU_NO_RUN}" != "${SBU_YES}" ]]; then
	  runner__run_all_test_files "$1"
	  return $?
	fi
}

function _main__initialise() {
  database__initialise
  trap _main__release EXIT
}

function _main__release() {
  database__release
}

function _main__parse_arguments() {
	local argument
	for argument in "$@"; do
		case "${argument}" in
			-a|--api-cheat-sheet)
			_main__print_api_cheat_sheet_and_exit
			;;
			-c=*|--colors=*)
			SBU_USE_COLORS="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-h|--help)
			_main__print_full_usage
			exit ${SBU_SUCCESS_STATUS_CODE}
			;;
			-f=*|--file-pattern=*)
			SBU_TEST_FILE_PATTERN="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			--no-run)
			SBU_NO_RUN="${SBU_YES}"
			(( parsed_arguments++ ))
			;;
			-o=*|--output-file=*)
			SBU_JUNIT_REPORTER_OUTPUT_FILE="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-t=*|--test-pattern=*)
			SBU_TEST_FUNCTION_PATTERN="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-r=*|--reporters=*)
			SBU_REPORTERS="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-*|--*)
			_main__print_illegal_option "${argument}"
      _main__print_usage_and_exit_with_code ${SBU_FAILURE_STATUS_CODE}
			;;
		esac
	done
}

function 	_main__assert_reporters_are_known() {
  reporter__for_each_reporter _main__fail_if_reporter_unknown
}

function _main__fail_if_reporter_unknown() {
  if ! system__array_contains "${reporter}" "simple" "dots" "junit"; then
    system__print_line \
      "$(_main__get_script_name): unknown reporter <${reporter}>"
    exit ${SBU_FAILURE_STATUS_CODE}
  fi
}

function _main__print_illegal_option() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  system__print_line "$(_main__get_script_name): illegal option -- ${option}"
}

function _main__assert_only_one_argument_left() {
  if (( $1 > 1 )); then
    system__print_line "$(_main__get_script_name): only one path is allowed"
    _main__print_usage_and_exit_with_code ${SBU_FAILURE_STATUS_CODE}
  fi
}

function _main__get_script_name() {
  basename "${BASH_SOURCE[0]}"
}

function _main__print_usage_and_exit_with_code() {
  _main__print_usage
	exit $1
}

function _main__print_full_usage() {
  _main__print_usage
  local script="$(_main__get_script_name)"
  system__print_new_line
  system__print_line "\
[options]
  -a, --api-cheat-sheet
    print api cheat sheet like assertions
  -c, --colors=${SBU_YES} or ${SBU_NO}
    tests output with colors or no
  -h
    print usage
  -f, --file-pattern=<pattern>
    pattern to filter test files
  -o, --output-file=<file>
    output file for JUnit reporter
  -t, --test-pattern=<pattern>
    pattern to filter test function in files
  -r, --reporters=<reporter1,reporter2>
    comma-separated reporters (simple, dots or junit)

[examples]
  ${script} .
    run all tests in current directory
  ${script} -p=*test.sh sources/test
    run all tests files ending with test.sh in sources/test"
}

function _main__print_usage() {
  system__print_line "\
usage: $(_main__get_script_name) [options] path
       run all tests in path"
}

function _main__print_api_cheat_sheet_and_exit() {
  system__print_line "\
[assertions]
  assertion__equal (value, other)
    -> assert that <value> is equal to <other>
  assertion__different (value, other)
    -> assert that <value> is different from <other>
  assertion__string_contains (string, substring)
    -> assert that <string> contains <substring>
  assertion__string_does_not_contain (string, substring)
    -> assert that <string> does not contain <substring>
  assertion__string_empty (string)
    -> assert that <string> is empty
  assertion__string_not_empty (string)
    -> assert that <string> is not empty
  assertion__array_contains (element, array[0], array[1], ...)
    -> assert that the <array> contains the <element>
  assertion__array_does_not_contain (element, array elements...)
    -> assert that the <array> does not contain the <element>
  assertion__successful (command)
    -> assert that the <command> is successful
  assertion__failing (command)
    -> assert that the <command> is failing
  assertion__status_code_is_success (code)
    -> assert that the status <code> is 0
  assertion__status_code_is_failure (code)
    -> assert that the status <code> is not 0

[special functions]
  ${SBU_GLOBAL_SETUP_FUNCTION_NAME}
    -> Executed before all tests in a file
  ${SBU_GLOBAL_TEARDOWN_FUNCTION_NAME}
    -> Executed after all tests in a file
  ${SBU_SETUP_FUNCTION_NAME}
    -> Executed before each test in a file
  ${SBU_TEARDOWN_FUNCTION_NAME}
    -> Executed after each test in a file"
  exit ${SBU_SUCCESS_STATUS_CODE}
}