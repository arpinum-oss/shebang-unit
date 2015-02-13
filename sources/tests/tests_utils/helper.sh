helper__use_silent_reporter() {
  source "${TEST_SOURCES_DIR}/tests_utils/mock_objects/silent_reporter.sh"
  SBU_REPORTERS=silent
}

helper__get_called_functions() {
  database__get "called_functions"
}

helper__function_called() {
  database__post "called_functions" "$1 "
}
