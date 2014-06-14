function junit_reporter__test_files_start_running() {
  _junit_reporter__initialise_report_with \
    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
  _junit_reporter__write_line_to_report "<testsuites>"
}

function junit_reporter__test_file_starts_running() {
  local file_name=$1
  local test_count=$2
  local suite_name="$(_junit_reporter__get_suite_name "${file_name}")"
  database__put "sbu_current_suite_name" "${suite_name}"
  _junit_reporter__write_line_to_report \
    "  <testsuite name=\"${suite_name}\" tests=\"${test_count}\">"
}

function junit_reporter__global_setup_has_failed() {
  :
}

function junit_reporter__test_starts_running() {
  local suite_name="$(database__get "sbu_current_suite_name")"
  _junit_reporter__write_line_to_report \
    "    <testcase name=\"$1\" classname=\"${suite_name}\" \
time=\"\${sbu_current_test_time}\">"
  database__put "sbu_current_test_ouput_lines" ""
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
    database__post_line "sbu_current_test_ouput_lines" "${text}"
  done
}

function junit_reporter__test_ends_running() {
  _junit_reporter__write_time_in_current_test_case_tag_in_report "$1"
  _junit_reporter__write_test_output_to_report_if_any
  _junit_reporter__write_line_to_report "    </testcase>"
}

function _junit_reporter__write_test_output_to_report_if_any() {
  local output="$(database__get "sbu_current_test_ouput_lines")"
  if [[ -n "${output}" ]]; then
    _junit_reporter__write_test_output_to_report "${output}"
  fi
}

function _junit_reporter__write_test_output_to_report() {
  _junit_reporter__write_line_to_report "      <system-out>"
  _junit_reporter__write_line_to_report "$(xml__encode_text "$1")"
  _junit_reporter__write_line_to_report "      </system-out>"
}

function _junit_reporter__write_time_in_current_test_case_tag_in_report() {
  local test_time=$1
  local report_content=$(cat "${SBU_JUNIT_REPORTER_OUTPUT_FILE}")
  local content_with_time="$(system__substitute_variable \
    "${report_content}" "sbu_current_test_time" "${test_time}")"
  system__print_line "${content_with_time}" > "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

function junit_reporter__test_file_ends_running() {
  _junit_reporter__write_line_to_report "  </testsuite>"
  database__put "sbu_current_suite_name" ""
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