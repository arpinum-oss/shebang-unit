function main__main() {
	configuration__load
  local parsed_arguments=0
  _main__parse_arguments "$@"
  shift ${parsed_arguments}
  _main__assert_only_one_argument_left $#
	_main__assert_reporters_are_known

	[[ "${SBU_NO_RUN}" != "${SBU_YES}" ]] \
	  && _main__run_all_test_files $1
}

function _main__parse_arguments() {
	local argument
	for argument in "$@"; do
		case "${argument}" in
			-c=*|--colors=*)
			SBU_USE_COLORS="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-p=*|--pattern=*)
			SBU_TEST_FILE_PATTERN="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			-r=*|--reporters=*)
			SBU_REPORTERS="${argument#*=}"
			(( parsed_arguments++ ))
			;;
			--no-run)
			SBU_NO_RUN="${SBU_YES}"
			(( parsed_arguments++ ))
			;;
			-h|--help)
			_main__print_full_usage
			exit ${SBU_SUCCESS_STATUS_CODE}
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
  if [[ "${reporter}" != "simple" && "${reporter}" != "dots" ]]; then
    printf "$(_main__get_script_name): unknown reporter <${reporter}>\n"
    exit ${SBU_FAILURE_STATUS_CODE}
  fi
}

function _main__print_illegal_option() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  printf "$(_main__get_script_name): illegal option -- ${option}\n"
}

function _main__assert_only_one_argument_left() {
  if (( $1 > 1 )); then
    printf "$(_main__get_script_name): only one path is allowed\n"
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
  printf "\n\
[options]
-c, --colors=${SBU_YES} or ${SBU_NO}
  tests output with colors or no
-h
  print usage
-p, --pattern=<pattern>
  pattern to filter test files in path
-r, --reporters=<reporter1,reporter2>
  comma-separated reporters

[examples]
${script} .
  run all tests in current directory
${script} -p=*test.sh sources/test
  run all tests files ending with test.sh in sources/test
\n"
}

function _main__print_usage() {
  printf "\
usage: $(_main__get_script_name) [options] path
       run all tests in path\n"
}

function _main__run_all_test_files() {
  _main__initialise
	runner__run_all_test_files "$1"
	local status=$?
	_main__release
	return ${status}
}

function _main__initialise() {
  database__initialise
  reporter__initialise
}

function _main__release() {
  reporter__release
  database__release
}