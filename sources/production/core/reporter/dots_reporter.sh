function dots_reporter__tests_files_end_running() {
	local color="$(_reporter__get_color_code_for_tests_result)"
	local texte="$(runner__tests_are_successful && printf "OK" || printf "KO")"
	system__print_line_with_color "${texte}" "${color}"
}

function dots_reporter__test_file_starts_running() {
	:
}

function dots_reporter__test_file_ends_running() {
	:
}

function dots_reporter__test_starts_running() {
	:
}

function dots_reporter__test_has_succeeded() {
  system__print_with_color "." ${SBU_GREEN_COLOR_CODE}
}

function dots_reporter__test_has_failed() {
  system__print_with_color "F" ${SBU_RED_COLOR_CODE}
}

function dots_reporter__assertion_failed() {
  :
}