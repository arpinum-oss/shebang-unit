junit_reporter__test_files_start_running() {
  _junit_reporter__initialise_report_with \
    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
  _junit_reporter__write_line_to_report "<testsuites>"
}

junit_reporter__test_file_starts_running() {
  local file_name=$1
  local test_count=$2
  local suite_name="$(_junit_reporter__get_suite_name "${file_name}")"
  database__put "sbu_current_suite_name" "${suite_name}"
  _junit_reporter__write_line_to_report \
    "  <testsuite name=\"${suite_name}\" tests=\"${test_count}\">"
  _junit_reporter__delete_all_outputs_lines "suite"
  _junit_reporter__redirect_outputs_to_database "suite"
}

junit_reporter__global_setup_has_failed() {
  :
}

junit_reporter__test_starts_running() {
  local suite_name="$(database__get "sbu_current_suite_name")"
  local test_name="$(xml__encode_text "$1")"
  _junit_reporter__write_line_to_report \
    "    <testcase name=\"${test_name}\" classname=\"${suite_name}\" \
time=\"\${sbu_current_test_time}\">"
  _junit_reporter__delete_all_outputs_lines "test"
  _junit_reporter__redirect_outputs_to_database "test"
}

junit_reporter__test_has_succeeded() {
  :
}

junit_reporter__test_has_failed() {
  _junit_reporter__write_line_to_report "      <failure>"
  _junit_reporter__write_line_to_report "      </failure>"
}

junit_reporter__test_is_skipped() {
  _junit_reporter__write_line_to_report "      <skipped>"
  _junit_reporter__write_line_to_report "      </skipped>"
}

junit_reporter__test_ends_running() {
  _junit_reporter__redirect_outputs_to_database "suite"
  _junit_reporter__write_time_in_current_test_case_tag_in_report "$1"
  _junit_reporter__flush_all_outputs_to_report_if_any "test"
  _junit_reporter__write_line_to_report "    </testcase>"
}

_junit_reporter__write_time_in_current_test_case_tag_in_report() {
  local test_time=$1
  local report_content=$(cat "${SBU_JUNIT_REPORTER_OUTPUT_FILE}")
  local content_with_time="$(system__substitute_variable \
    "${report_content}" "sbu_current_test_time" "${test_time}")"
  system__print_line \
    "${content_with_time}" > "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

junit_reporter__test_file_ends_running() {
  _junit_reporter__flush_all_outputs_to_report_if_any "suite"
  _junit_reporter__write_line_to_report "  </testsuite>"
  database__put "sbu_current_suite_name" ""
}

junit_reporter__test_files_end_running() {
  _junit_reporter__write_line_to_report "</testsuites>"
}

_junit_reporter__get_suite_name() {
  local relative_name="$(reporter__get_test_file_relative_name "$1")"
  local dots_replaced_by_underscores="${relative_name//./_}"
  local slashes_replaced_by_dots="${dots_replaced_by_underscores//\//.}"
  xml__encode_text "${slashes_replaced_by_dots}"
}

_junit_reporter__initialise_report_with() {
  system__print_line "$1" > "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

_junit_reporter__write_line_to_report() {
  system__print_line "$1" >> "${SBU_JUNIT_REPORTER_OUTPUT_FILE}"
}

_junit_reporter__redirect_outputs_to_database() {
  local scope=$1
  exec 1>>\
    "$(database__get_descriptor "sbu_current_${scope}_standard_ouputs_lines")"
  exec 2>>\
    "$(database__get_descriptor "sbu_current_${scope}_error_ouputs_lines")"
}

_junit_reporter__delete_all_outputs_lines() {
  database__put "sbu_current_$1_standard_ouputs_lines"
  database__put "sbu_current_$1_error_ouputs_lines"
}

_junit_reporter__flush_all_outputs_to_report_if_any() {
  _junit_reporter__flush_outputs_to_report_if_any "$1" "standard"
  _junit_reporter__flush_outputs_to_report_if_any "$1" "error"
}

_junit_reporter__flush_outputs_to_report_if_any() {
  local scope=$1
  local outputs_type=$2
  local key="sbu_current_${scope}_${outputs_type}_ouputs_lines"
  local outputs="$(database__get "${key}")"
  if [[ -n "${outputs}" ]]; then
    _junit_reporter__write_outputs_to_report \
      "${scope}" "${outputs_type}" "${outputs}"
    database__put "${key}" ""
  fi
}

_junit_reporter__write_outputs_to_report() {
  local scope=$1
  local outputs_type=$2
  local outputs=$3
  local tag="$(_junit_reporter__get_tag_for_outputs_type "${outputs_type}")"
  local indentation="$(_junit_reporter__get_indentation_for_scope "${scope}")"
  _junit_reporter__write_line_to_report "${indentation}<${tag}>"
  _junit_reporter__write_line_to_report "$(xml__encode_text "${outputs}")"
  _junit_reporter__write_line_to_report "${indentation}</${tag}>"
}

_junit_reporter__get_tag_for_outputs_type() {
  [[ "$1" == "standard" ]] \
    && system__print "system-out" \
    || system__print "system-err"
}

_junit_reporter__get_indentation_for_scope() {
  [[ "$1" == "suite" ]] \
    && system__print "    " \
    || system__print "      "
}
