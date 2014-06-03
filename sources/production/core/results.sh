function results__tests_files_start_running() {
  sbu_global_successful_tests_count=0
	sbu_global_failing_tests_count=0
	sbu_global_run_beginning_date="$(system__get_date_in_seconds)"
}

function results__tests_files_end_running() {
  sbu_global_run_ending_date="$(system__get_date_in_seconds)"
}

function results__get_run_time() {
  printf "$((${sbu_global_run_ending_date} - ${sbu_global_run_beginning_date}))"
}

function results__get_successful_tests_count() {
  printf "${sbu_global_successful_tests_count}"
}

function results__increment_successful_tests() {
  (( sbu_global_successful_tests_count++ ))
}

function results__get_failing_tests_count() {
  printf "${sbu_global_failing_tests_count}"
}

function results__increment_failing_tests() {
  (( sbu_global_failing_tests_count++ ))
}
