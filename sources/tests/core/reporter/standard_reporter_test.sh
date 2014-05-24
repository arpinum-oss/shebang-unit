_TEMPORARY_FILE_FOR_TESTS_OUTPUT="/tmp/sbu.txt"
_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../../../production"
_TEST_DIRECTORY="${_SOURCE_DIRECTORY}/../../../../resources/tests/\
directory_with_two_tests"

function global_setup() {
	( source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	  SBU_USE_COLORS=${SBU_NO}
	  runner__run_all_test_files "${_TEST_DIRECTORY}" \
	    > "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}" )
}

function global_teardown() {
	rm -rf "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}"
}

function can_report_tests_runs() {
  local expected="[File] ./sources/tests/core/reporter/../../../../resources/tests/directory_with_two_tests/first_test.sh
[Test] successful_test_function
OK
[Test] successful_test_function_indented
OK
[Test] failing_test_function
Assertion failed. Actual: <2>, expected: <3>.
KO

[File] ./sources/tests/core/reporter/../../../../resources/tests/directory_with_two_tests/second_test.sh
[Test] successful_test_function
OK

[Results]
Green tests: 3, red: 1 in 0s"

  assertion__string_contains "$(cat "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}")" "${expected}"
}