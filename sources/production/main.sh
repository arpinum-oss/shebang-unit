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
		esac
	done

	runner__run_all_test_files $1
}