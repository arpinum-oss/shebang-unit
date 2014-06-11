function junit_reporter__test_files_start_running() {
  _junit_reporter__initialise_report_with \
    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
  _junit_reporter__write_line_to_report "<testsuites>"
}

function junit_reporter__test_file_starts_running() {
  local file_name=$1
  local test_count=$2
  sbu_current_suite_name="$(_junit_reporter__get_suite_name "${file_name}")"
  _junit_reporter__write_line_to_report \
    "  <testsuite name=\"${sbu_current_suite_name}\" tests=\"${test_count}\">"
}

function junit_reporter__global_setup_has_failed() {
  :
}

function junit_reporter__test_starts_running() {
  _junit_reporter__write_line_to_report \
    "    <testcase name=\"$1\" classname=\"${sbu_current_suite_name}\">"
}

function junit_reporter__test_has_succeeded() {
  :
}

function junit_reporter__test_has_failed() {
  _junit_reporter__write_line_to_report "      <failure>"
  _junit_reporter__write_line_to_report "      </failure>"
}

function junit_reporter__test_is_skipped() {
  _junit_reporter__write_line_to_report "      <skipped>"
  _junit_reporter__write_line_to_report "      </skipped>"
}

function junit_reporter__redirect_test_output() {
  local text
  while read text; do
    :
  done
}

function junit_reporter__test_ends_running() {
  _junit_reporter__write_line_to_report "    </testcase>"
}

function junit_reporter__test_file_ends_running() {
  _junit_reporter__write_line_to_report "  </testsuite>"
  sbu_current_suite_name=""
}

function junit_reporter__test_files_end_running() {
  _junit_reporter__write_line_to_report "</testsuites>"
}

function _junit_reporter__get_suite_name() {
  local test_file_name="$(system__print "$1" | sed "s|^.*/\(.*\)|\\1|")"
  system__print "${test_file_name//./_}"
}

function _junit_reporter__initialise_report_with() {
  system__print_line "$1" > "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

function _junit_reporter__write_line_to_report() {
  system__print_line "$1" >> "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}