function main__main() {
	local argument
	for argument in "$@"; do
		case "${argument}" in
			-c=*|--colors=*)
			SBU_USE_COLORS="${argument#*=}"
			shift
			;;
			-p=*|--pattern=*)
			SBU_TEST_FILE_PATTERN="${argument#*=}"
			shift
			;;
			-r=*|--reporters=*)
			SBU_REPORTERS="${argument#*=}"
			shift
			;;
			-h|--help)
			_main__print_full_usage
			exit ${SBU_SUCCESS_STATUS_CODE}
			;;
			-*|--*)
			_main_print_illegal_option "${argument}"
      _main__print_usage_and_exit_with_code ${SBU_FAILURE_STATUS_CODE}
			;;
		esac
	done

	_main__assert_only_one_argument_left $#
	_main__assert_reporters_are_known
	runner__run_all_test_files $1
}

function 	_main__assert_reporters_are_known() {
  reporter__for_each_reporter _fail_if_reporter_unknown
}

function _fail_if_reporter_unknown() {
  if [[ "${reporter}" != "simple" && "${reporter}" != "dots" ]]; then
    printf "$(_main__get_script_name): unknown reporter <${reporter}>\n"
    exit ${SBU_FAILURE_STATUS_CODE}
  fi
}

function _main_print_illegal_option() {
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
  _main_print_usage
	exit $1
}

function _main__print_full_usage() {
  _main_print_usage
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

function _main_print_usage() {
  printf "\
usage: $(_main__get_script_name) [options] path
       run all tests in path\n"
}