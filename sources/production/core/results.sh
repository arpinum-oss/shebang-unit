function results__tests_files_start_running() {
  global_successful_tests_count=0
	global_failing_tests_count=0
	global_run_beginning_date="$(system__get_date_in_seconds)"
}

function results__tests_files_end_running() {
  global_run_ending_date="$(system__get_date_in_seconds)"
}

function results__get_run_time() {
  printf "$((${global_run_ending_date} - ${global_run_beginning_date}))"
}

function results__get_successful_tests_count() {
  printf "${global_successful_tests_count}"
}

function results__increment_successful_tests() {
  (( global_successful_tests_count++ ))
}

function results__get_failing_tests_count() {
  printf "${global_failing_tests_count}"
}

function results__increment_failing_tests() {
  (( global_failing_tests_count++ ))
}
