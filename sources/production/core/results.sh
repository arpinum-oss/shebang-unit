function results__tests_files_start_running() {
  database__put "sbu_successful_tests_count" "0"
  database__put "sbu_failing_tests_count" "0"
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
  database__get "sbu_successful_tests_count"
}

function results__increment_successful_tests() {
  local count="$(results__get_successful_tests_count)"
  database__put "sbu_successful_tests_count" "$(( count + 1 ))"
}

function results__get_failing_tests_count() {
  database__get "sbu_failing_tests_count"
}

function results__increment_failing_tests() {
  local count="$(results__get_failing_tests_count)"
  database__put "sbu_failing_tests_count" "$(( count + 1 ))"
}
