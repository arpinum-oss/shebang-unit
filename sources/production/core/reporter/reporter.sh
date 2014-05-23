function reporter__tests_files_end_running() {
	"$(_reporter__get)_reporter__tests_files_end_running" "$@"
}

function reporter__test_starts_running() {
	"$(_reporter__get)_reporter__test_starts_running" "$@"
}

function reporter__test_has_succeeded() {
  "$(_reporter__get)_reporter__test_has_succeeded" "$@"
}

function reporter__test_has_failed() {
  "$(_reporter__get)_reporter__test_has_failed" "$@"
}

function reporter__test_file_starts_running() {
	"$(_reporter__get)_reporter__test_file_starts_running" "$@"
}

function reporter__test_file_ends_running() {
	"$(_reporter__get)_reporter__test_file_ends_running" "$@"
}

function _reporter__get() {
  printf "standard"
}

function _reporter__print_with_color() {
	system__print_with_color "$1" "$2" "${SBU_DEFAULT_COLOR_CODE}"
}

function _reporter__get_color_code_for_tests_result() {
	local color_code=${SBU_GREEN_COLOR_CODE}
	if ! runner__tests_are_successful; then
		color_code=${SBU_RED_COLOR_CODE}
	fi
	printf "${color_code}"
}
