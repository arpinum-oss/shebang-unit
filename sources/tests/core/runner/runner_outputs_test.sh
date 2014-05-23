_TEMPORARY_FILE_FOR_TESTS_OUTPUT="/tmp/sbu.txt"
_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../../../production"
_TEST_DIRECTORY="${_SOURCE_DIRECTORY}/../../../../resources/tests/\
directory_with_two_tests"

function global_setup() {
	( source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	  runner__run_all_test_files "${_TEST_DIRECTORY}" \
	    > "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}" )
}

function global_teardown() {
	rm -rf "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}"
}

function the_runner_print_successful_and_failing_test_number() {
	local last_line="$(tail -n1 "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}")"

	assertion__string_contains "${last_line}" "Green tests: 3, red: 1"
}