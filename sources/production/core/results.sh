function results__tests_files_start_running() {
  database__put "sbu_successful_tests_count" "0"
  database__put "sbu_failing_tests_count" "0"
  database__put "sbu_total_tests_count" "0"
  database__put "sbu_run_beginning_date" "$(system__get_date_in_seconds)"
}

function results__tests_files_end_running() {
  database__put "sbu_run_ending_date" "$(system__get_date_in_seconds)"
}

function results__get_run_time() {
  local beginning_date="$(database__get "sbu_run_beginning_date")"
  local ending_date="$(database__get "sbu_run_ending_date")"
  printf "$(( ending_date - beginning_date ))"
}

function results__get_successful_tests_count() {
  _results__get_tests_count_of_type "successful"
}

function results__increment_successful_tests() {
  _results__increment_by_n_tests_of_type 1 "successful"
}

function results__get_failing_tests_count() {
  _results__get_tests_count_of_type "failing"
}

function results__increment_failing_tests() {
  _results__increment_by_n_tests_of_type 1 "failing"
}

function results__get_total_tests_count() {
  _results__get_tests_count_of_type "total"
}

function results__increment_by_n_total_tests_count() {
  _results__increment_by_n_tests_of_type "$1" "total"
}

function results__get_not_run_tests_count() {
  local total="$(results__get_total_tests_count)"
  local successes="$(results__get_successful_tests_count)"
  local failures="$(results__get_failing_tests_count)"
  printf "$(( total - (successes + failures) ))"
}

function _results__get_tests_count_of_type() {
  local type=$1
  database__get "sbu_${type}_tests_count"
}

function _results__increment_by_n_tests_of_type() {
  local value=$1
  local type=$2
  local count="$(results__get_${type}_tests_count)"
  database__put "sbu_${type}_tests_count" "$(( count + value ))"
}
