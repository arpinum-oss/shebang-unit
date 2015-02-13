can_assert_equality() {
  assertion__equal 4 $((3+1))
}

can_assert_that_string_contains_another_one() {
  assertion__string_contains "Cool dog is cool" "cool"
}

can_assert_that_string_does_not_contain_another_one() {
  assertion__string_does_not_contain "Monorail cat" "Caturday"
}

can_assert_that_string_is_empty() {
  assertion__string_empty ""
}

can_assert_that_string_is_not_empty() {
  assertion__string_not_empty "Don't feed the zombies"
}

can_assert_that_array_contains_element() {
  local lost_numbers=(4 8 15 16 23 42)

  assertion__array_contains 15 "${lost_numbers[@]}"
}

can_assert_that_array_does_not_contain_element() {
  local lost_numbers=(4 8 15 16 23 42)

  assertion__array_does_not_contain 1337 "${lost_numbers[@]}"
}

can_assert_that_status_code_is_success() {
  true

  assertion__status_code_is_success $?
}

can_assert_that_status_code_is_failure() {
  false

  assertion__status_code_is_failure $?
}

can_assert_that_command_is_successful() {
  assertion__successful true
}

can_assert_that_command_is_failing() {
  assertion__failing false
}

can_mock_pwd_to_do_nothing() {
  mock__make_function_do_nothing "pwd"

  assertion__equal "" "$(pwd)"
}

can_mock_pwd_to_print_root() {
  mock__make_function_prints "pwd" "/"

  assertion__equal "/" "$(pwd)"
}

can_mock_pwd_to_call_a_custom_function() {
  mock__make_function_call "pwd" "printf hello"

  assertion__equal "hello" "$(pwd)"
}
