function reporter__tests_files_end_running() {
	reporter__for_each_reporter \
	  _reporter__call_function tests_files_end_running "$@"
}

function reporter__test_starts_running() {
	reporter__for_each_reporter \
	  _reporter__call_function test_starts_running "$@"
}

function reporter__test_has_succeeded() {
	reporter__for_each_reporter \
	  _reporter__call_function test_has_succeeded "$@"
}

function reporter__test_has_failed() {
	reporter__for_each_reporter \
	  _reporter__call_function test_has_failed "$@"
}

function reporter__test_file_starts_running() {
	reporter__for_each_reporter \
	  _reporter__call_function test_file_starts_running "$@"
}

function reporter__test_file_ends_running() {
	reporter__for_each_reporter \
	  _reporter__call_function test_file_ends_running "$@"
}

function reporter__assertion_failed() {
	reporter__for_each_reporter \
	  _reporter__call_function assertion_failed "$@"
}

function _reporter__call_function() {
  local function=$1
  shift 1
  "${reporter}_reporter__${function}" "$@"
}

function reporter__for_each_reporter() {
  local reporter
  for reporter in ${SBU_REPORTERS//${SBU_VALUE_SEPARATOR}/ }; do
    "$@"
  done
}

function _reporter__get_color_code_for_tests_result() {
	local color_code=${SBU_GREEN_COLOR_CODE}
	if ! runner__tests_are_successful; then
		color_code=${SBU_RED_COLOR_CODE}
	fi
	printf "${color_code}"
}
