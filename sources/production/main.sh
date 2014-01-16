function main__main() {
	local i
	for i in "$@"; do
		case "${i}" in
			-c=*|--colors=*)
			SBU_USE_COLORS="${i#*=}"
			shift
			;;
			-p=*|--pattern=*)
			SBU_TEST_FILE_PATTERN="${i#*=}"
			shift
			;;
			-h|--help)
			_main_print_usage
			exit ${SBU_SUCCESS_STATUS_CODE}
			shift
			;;
			-*=*|--*=*)
			_main_print_illegal_option "${i}"
      _main_print_usage
			exit ${SBU_FAILURE_STATUS_CODE}
			;;
		esac
	done

	runner__run_all_test_files $1
}

function _main_print_illegal_option() {
  local option="${1%=*}"
  option="${option#-}"
  option="${option#-}"
  printf "$(basename "$0"): illegal option -- ${option}"
}

function _main_print_usage() {
  local script="$(basename "$0")"
  printf "\
[usage]
${script} [options] path
  run all tests in path

[options]
-c, --colors=${SBU_YES} or ${SBU_NO}
  tests output with colors or no
-h
  print usage
-p, --pattern=<pattern>
  pattern to filter test files in path

[examples]
${script} .
  run all tests in current directory
${script} -p=*test.sh sources/test
  run all tests files ending with test.sh in sources/test
\n"
}