function simple_reporter__tests_files_end_running() {
	printf "[Results]\n"
	local color="$(_reporter__get_color_code_for_tests_result)"
	local total_count="$(_simple_reporter__get_total_count_message)"
	local failures_count="$(_simple_reporter__get_failures_count_message)"
	local not_run_count="$(results__get_not_run_tests_count) not run"
	local time="in $(results__get_run_time)s"
	local message="${total_count}, ${failures_count}, ${not_run_count} ${time}"
	system__print_line_with_color "${message}" "${color}"
}

function _simple_reporter__get_total_count_message() {
  local count="$(results__get_total_tests_count)"
  printf "${count} test$(_simple_reporter__get_agreement ${count})"
}

function _simple_reporter__get_failures_count_message() {
  local count="$(results__get_failing_tests_count)"
  printf "${count} failure$(_simple_reporter__get_agreement ${count})"
}

function _simple_reporter__get_agreement() {
  (( $1 > 1 )) && printf "s"
}

function simple_reporter__test_file_starts_running() {
	printf "[File] $1\n"
}

function simple_reporter__test_file_ends_running() {
	printf "\n"
}

function simple_reporter__test_starts_running() {
	printf "[Test] $1\n"
}

function simple_reporter__test_has_succeeded() {
  system__print_line_with_color "OK" ${SBU_GREEN_COLOR_CODE}
}

function simple_reporter__test_has_failed() {
  system__print_line_with_color "KO" ${SBU_RED_COLOR_CODE}
}

function simple_reporter__redirect_test_output() {
  local text
  while read text; do
    printf "${text}\n"
  done
}