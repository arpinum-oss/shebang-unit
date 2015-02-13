setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/mock_objects/first_reporter.sh"
  source "${TEST_SOURCES_DIR}/core/reporter/mock_objects/second_reporter.sh"
  SBU_REPORTERS=first,second
}

can_execute_for_each_reporters() {
  SBU_REPORTERS=toto,tutu
  local read_reporters=""

  reporter__for_each_reporter _put_read_reporter

  assertion__equal "toto#tutu" "${read_reporters}"
}

can_call_for_each_reporter__test_files_start_running() {
  _can_call_for_each_reporter "test_files_start_running"
}

can_call_for_each_reporter__test_file_starts_running() {
  _can_call_for_each_reporter "test_file_starts_running"
}

can_call_for_each_reporter__global_setup_has_failed() {
  _can_call_for_each_reporter "global_setup_has_failed"
}

can_call_for_each_reporter__test_starts_running() {
  _can_call_for_each_reporter "test_starts_running"
}

can_call_for_each_reporter__test_has_succeeded() {
  _can_call_for_each_reporter "test_has_succeeded"
}

can_call_for_each_reporter__test_has_failed() {
  _can_call_for_each_reporter "test_has_failed"
}

can_call_for_each_reporter__test_is_skipped() {
  _can_call_for_each_reporter "test_is_skipped"
}

can_call_for_each_reporter__test_ends_running() {
  _can_call_for_each_reporter "test_ends_running"
}

can_call_for_each_reporter__test_file_ends_running() {
  _can_call_for_each_reporter "test_file_ends_running"
}

can_call_for_each_reporter__test_files_end_running() {
  mock__make_function_do_nothing "_reporter__release_file_descriptors"

  _can_call_for_each_reporter "test_files_end_running"
}

_can_call_for_each_reporter() {
  local function=$1

  local messages="$("reporter__${function}" a b)"

  local first="first_reporter__${function} with [a, b]"
  local second="second_reporter__${function} with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

_put_read_reporter() {
  [[ -z "${read_reporters}" ]] \
    && read_reporters="${reporter}" \
    || read_reporters="${read_reporters}#${reporter}"
}
