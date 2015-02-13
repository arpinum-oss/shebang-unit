results__test_files_start_running() {
  database__put "sbu_successful_tests_count" "0"
  database__put "sbu_failing_tests_count" "0"
  database__put "sbu_skipped_tests_count" "0"
}

results__get_successful_tests_count() {
  _results__get_tests_count_of_type "successful"
}

results__increment_successful_tests() {
  _results__increment_tests_of_type "successful"
}

results__get_failing_tests_count() {
  _results__get_tests_count_of_type "failing"
}

results__increment_failing_tests() {
  _results__increment_tests_of_type "failing"
}

results__get_skipped_tests_count() {
  _results__get_tests_count_of_type "skipped"
}

results__increment_skipped_tests() {
  _results__increment_tests_of_type "skipped"
}

results__get_total_tests_count() {
  local successes="$(results__get_successful_tests_count)"
  local failures="$(results__get_failing_tests_count)"
  local skipped="$(results__get_skipped_tests_count)"
  system__print "$(( successes + failures + skipped ))"
}

_results__get_tests_count_of_type() {
  local type=$1
  database__get "sbu_${type}_tests_count"
}

_results__increment_tests_of_type() {
  local type=$1
  local count="$(results__get_${type}_tests_count)"
  database__put "sbu_${type}_tests_count" "$(( count + 1 ))"
}
