_TEMPORARY_FILE_FOR_TESTS_OUTPUT="/tmp/sbu.txt"
_SOURCE_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
_PRODUCTION_DIRECTORY="${_SOURCE_DIRECTORY}/../../../production"
_TEST_DIRECTORY="${_SOURCE_DIRECTORY}/../../../../resources/tests/\
directory_with_two_tests"

function global_setup() {
	( source "${_PRODUCTION_DIRECTORY}/configuration.sh"
	  SBU_REPORTERS="dots"
	  _stub_runner_to_return_1337s_for_exection_time
	  runner__run_all_test_files "${_TEST_DIRECTORY}" \
	    > "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}" )
}

function _stub_runner_to_return_1337s_for_exection_time() {
  eval "function _runner__get_execution_time() { printf "1337"; }"
}

function global_teardown() {
	#rm -rf "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}"
	:
}

function can_report_tests_runs() {
  local expected_output_file="${_SOURCE_DIRECTORY}/../../../../resources/tests/reporter/\
dots_reporter_output_with_failures.txt"

  assertion__equal "$(cat "${_TEMPORARY_FILE_FOR_TESTS_OUTPUT}")" \
                   "$(cat "${expected_output_file}")"
}