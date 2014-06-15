function setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/mock_objects/first_reporter.sh"
  source "${TEST_SOURCES_DIR}/core/reporter/mock_objects/second_reporter.sh"
  source "${TEST_SOURCES_DIR}/tests_utils/mock.sh"
  SBU_REPORTERS=first,second
}

function can_execute_for_each_reporters() {
  SBU_REPORTERS=toto,tutu
  local read_reporters=""

  reporter__for_each_reporter _put_read_reporter

  assertion__equal "toto#tutu" "${read_reporters}"
}

function can_call_for_each_reporter__test_files_start_running() {
  _can_call_for_each_reporter "test_files_start_running"
}

function can_call_for_each_reporter__test_file_starts_running() {
  _can_call_for_each_reporter "test_file_starts_running"
}

function can_call_for_each_reporter__global_setup_has_failed() {
  _can_call_for_each_reporter "global_setup_has_failed"
}

function can_call_for_each_reporter__test_starts_running() {
  _can_call_for_each_reporter "test_starts_running"
}

function can_call_for_each_reporter__test_has_succeeded() {
  _can_call_for_each_reporter "test_has_succeeded"
}

function can_call_for_each_reporter__test_has_failed() {
  _can_call_for_each_reporter "test_has_failed"
}

function can_call_for_each_reporter__test_is_skipped() {
  _can_call_for_each_reporter "test_is_skipped"
}

function can_call_for_each_reporter__test_ends_running() {
  _can_call_for_each_reporter "test_ends_running"
}

function can_call_for_each_reporter__test_file_ends_running() {
  _can_call_for_each_reporter "test_file_ends_running"
}

function can_call_for_each_reporter__test_files_end_running() {
  mock__make_function_do_nothing "_reporter__release_file_descriptors"

  _can_call_for_each_reporter "test_files_end_running"
}

function _can_call_for_each_reporter() {
  local function=$1

  local messages="$("reporter__${function}" a b)"

  local first="first_reporter__${function} with [a, b]"
  local second="second_reporter__${function} with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function _put_read_reporter() {
  [[ -z "${read_reporters}" ]] \
    && read_reporters="${reporter}" \
    || read_reporters="${read_reporters}#${reporter}"
}