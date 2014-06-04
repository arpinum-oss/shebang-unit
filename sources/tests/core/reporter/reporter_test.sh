function setup() {
  source "${TEST_SOURCES_DIR}/core/reporter/mock/first_reporter.sh"
  source "${TEST_SOURCES_DIR}/core/reporter/mock/second_reporter.sh"
  SBU_REPORTERS_FD=1
  SBU_REPORTERS=first,second
}

function can_execute_for_each_reporters() {
  SBU_REPORTERS=toto,tutu
  local read_reporters=""

  reporter__for_each_reporter _put_read_reporter

  assertion__equal "toto#tutu" "${read_reporters}"
}

function can_call_for_each_reporter__tests_files_end_running() {
  local messages="$(reporter__tests_files_end_running a b)"

  local first="first_reporter__tests_files_end_running with [a, b]"
  local second="second_reporter__tests_files_end_running with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function can_call_for_each_reporter__test_starts_running() {
  local messages="$(reporter__test_starts_running a b)"

  local first="first_reporter__test_starts_running with [a, b]"
  local second="second_reporter__test_starts_running with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function can_call_for_each_reporter__test_has_succeeded() {
  local messages="$(reporter__test_has_succeeded a b)"

  local first="first_reporter__test_has_succeeded with [a, b]"
  local second="second_reporter__test_has_succeeded with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function can_call_for_each_reporter__test_has_failed() {
  local messages="$(reporter__test_has_failed a b)"

  local first="first_reporter__test_has_failed with [a, b]"
  local second="second_reporter__test_has_failed with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function can_call_for_each_reporter__test_file_starts_running() {
  local messages="$(reporter__test_file_starts_running a b)"

  local first="first_reporter__test_file_starts_running with [a, b]"
  local second="second_reporter__test_file_starts_running with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function can_call_for_each_reporter__test_file_ends_running() {
  local messages="$(reporter__test_file_ends_running a b)"

  local first="first_reporter__test_file_ends_running with [a, b]"
  local second="second_reporter__test_file_ends_running with [a, b]"
  assertion__equal "${first}"$'\n'"${second}" "${messages}"
}

function _put_read_reporter() {
  [[ -z "${read_reporters}" ]] \
    && read_reporters="${reporter}" \
    || read_reporters="${read_reporters}#${reporter}"
}