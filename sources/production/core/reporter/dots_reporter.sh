function dots_reporter__test_files_start_running() {
  _dots_reporter__redirect_outputs_to_trash
}

function dots_reporter__test_file_starts_running() {
	:
}

function dots_reporter__global_setup_has_failed() {
  :
}

function dots_reporter__test_starts_running() {
	:
}

function dots_reporter__test_has_succeeded() {
  _dots_reporter__cancel_outputs_redirection
  system__print_with_color "." ${SBU_GREEN_COLOR_CODE}
  _dots_reporter__redirect_outputs_to_trash
}

function dots_reporter__test_has_failed() {
  _dots_reporter__cancel_outputs_redirection
  system__print_with_color "F" ${SBU_RED_COLOR_CODE}
  _dots_reporter__redirect_outputs_to_trash
}

function dots_reporter__test_is_skipped() {
  _dots_reporter__cancel_outputs_redirection
  system__print_with_color "S" ${SBU_YELLOW_COLOR_CODE}
  _dots_reporter__redirect_outputs_to_trash
}

function dots_reporter__redirect_test_output() {
  local text
  while read text; do
   :
  done
}

function dots_reporter__test_ends_running() {
  :
}

function dots_reporter__test_file_ends_running() {
	:
}

function dots_reporter__test_files_end_running() {
  _dots_reporter__cancel_outputs_redirection
	local color="$(_reporter__get_color_code_for_tests_result)"
	local texte="$(runner__tests_are_successful \
	                && system__print "OK" \
	                || system__print "KO")"
	system__print_line_with_color "${texte}" "${color}"
}

_dots_reporter__redirect_outputs_to_trash() {
  exec 8>&1 1>/dev/null
  exec 9>&2 2>/dev/null
}

_dots_reporter__cancel_outputs_redirection() {
  exec 1>&8
  exec 2>&9
}