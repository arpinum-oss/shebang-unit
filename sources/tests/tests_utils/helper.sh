function helper__use_silent_reporter() {
  source "${TEST_SOURCES_DIR}/tests_utils/mock/silent_reporter.sh"
  SBU_REPORTERS=silent
}

function helper__get_called_functions() {
	database__get "called_functions"
}

function helper__function_called() {
  database__post "called_functions" "$1 "
}