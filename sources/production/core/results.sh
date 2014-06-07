function results__tests_files_start_running() {
  database__put "sbu_successful_tests_count" "0"
  database__put "sbu_failing_tests_count" "0"
  database__put "sbu_not_run_tests_count" "0"
  database__put "sbu_run_beginning_date" "$(system__get_date_in_seconds)"
}

function results__tests_files_end_running() {
  database__put "sbu_run_ending_date" "$(system__get_date_in_seconds)"
}

function results__get_run_time() {
  local beginning_date="$(database__get "sbu_run_beginning_date")"
  local ending_date="$(database__get "sbu_run_ending_date")"
  system__print "$(( ending_date - beginning_date ))"
}

function results__get_successful_tests_count() {
  _results__get_tests_count_of_type "successful"
}

function results__increment_successful_tests() {
  _results__increment_tests_of_type "successful"
}

function results__get_failing_tests_count() {
  _results__get_tests_count_of_type "failing"
}

function results__increment_failing_tests() {
  _results__increment_tests_of_type "failing"
}

function results__get_not_run_tests_count() {
  _results__get_tests_count_of_type "not_run"
}

function results__increment_not_run_tests() {
  _results__increment_tests_of_type "not_run"
}

function results__get_total_tests_count() {
  local successes="$(results__get_successful_tests_count)"
  local failures="$(results__get_failing_tests_count)"
  local not_run="$(results__get_not_run_tests_count)"
  system__print "$(( successes + failures + not_run ))"
}

function _results__get_tests_count_of_type() {
  local type=$1
  database__get "sbu_${type}_tests_count"
}

function _results__increment_tests_of_type() {
  local type=$1
  local count="$(results__get_${type}_tests_count)"
  database__put "sbu_${type}_tests_count" "$(( count + 1 ))"
}
