function if_tests_fail_main_fails_too() {
  local directory="${TESTS_RESOURCES_DIR}/main/one_failing_test"

  ( configuration_load
    main__main "${directory}" > /dev/null )

  assertion__status_code_is_failure $?
}