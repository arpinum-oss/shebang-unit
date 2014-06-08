function first_reporter__tests_files_end_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__global_setup_has_failed() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_starts_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_has_succeeded() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_has_failed() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_is_skipped() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_file_starts_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__test_file_ends_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function first_reporter__assertion_failed() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}