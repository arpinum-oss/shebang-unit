function test_runner__run_test() {
	local test_function=$1
	shift 1
  reporter__test_starts_running "${test_function}"
	timer__store_current_time "test_time"
	(
	  _test_runner__call_setup_if_exists "$@" \
	    && _test_runner__call_test_fonction "${test_function}"
	  local setup_and_test_code=$?
	  _test_runner__call_teardown_if_exists "$@"
	  (( $? == ${SBU_SUCCESS_STATUS_CODE} \
	  &&  ${setup_and_test_code} == ${SBU_SUCCESS_STATUS_CODE} ))
	)
	_test_runner__parse_test_function_result $?
	reporter__test_ends_running "$(timer__get_time_elapsed "test_time")"
}

function _test_runner__call_test_fonction() {
  ( "$1" )
}

function _test_runner__call_setup_if_exists() {
  _test_runner__call_function_if_exits "${SBU_SETUP_FUNCTION_NAME}" "$@"
}

function _test_runner__call_teardown_if_exists() {
  _test_runner__call_function_if_exits "${SBU_TEARDOWN_FUNCTION_NAME}" "$@"
}

function _test_runner__parse_test_function_result() {
	if (( $1 == ${SBU_SUCCESS_STATUS_CODE} )); then
		results__increment_successful_tests
		reporter__test_has_succeeded
	else
		results__increment_failing_tests
		reporter__test_has_failed
	fi
}

function _test_runner__call_function_if_exits() {
	local function=$1
	shift 1
	if system__array_contains "${function}" "$@"; then
	  "${function}"
	fi
}

function test_runner__skip_test() {
  local test_function=$1
  reporter__test_starts_running "${test_function}"
  results__increment_skipped_tests
  reporter__test_is_skipped "${test_function}"
  reporter__test_ends_running 0
}