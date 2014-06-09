function second_reporter__test_files_start_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_file_starts_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__global_setup_has_failed() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_starts_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_has_succeeded() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_has_failed() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_is_skipped() {
  printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_file_ends_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}

function second_reporter__test_files_end_running() {
	printf "${FUNCNAME} with $(system__print_array "$@")\n"
}