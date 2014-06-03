function simple_reporter__tests_files_end_running() {
	printf "[Results]\n"
	local color="$(_reporter__get_color_code_for_tests_result)"
	local green_tests="Green tests: $(results__get_successful_tests_count)"
	local red_tests="red: $(results__get_failing_tests_count)"
	local time="in $(results__get_run_time)s"
	local message="${green_tests}, ${red_tests} ${time}"
	system__print_line_with_color "${message}" "${color}"
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