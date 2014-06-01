function setup() {
	message=""
}

function asserting_that_successful_command_has_success_status_code_is_true() {
	message="$(assertion__status_code_is_success 0)"

	_assert_success
	_assert_message_empty
}

function asserting_that_failing_command_has_success_status_code_is_false() {
	message="$(assertion__status_code_is_success 1)"

	_assert_failure
	_assert_message_equals "Status code is failure instead of success."
}

function can_print_custom_message_for_success_status_code_assertion() {
	message="$(assertion__status_code_is_success 1 "custom message")"

  local expected="Status code is failure instead of success. custom message"
	_assert_message_equals "${expected}"
}

function asserting_that_failing_command_has_failure_status_code_is_true() {
	message="$(assertion__status_code_is_failure 1)"

	_assert_success
	_assert_message_empty
}

function asserting_that_successful_command_has_failure_status_code_is_false() {
	message="$(assertion__status_code_is_failure 0)"

	_assert_failure
	_assert_message_equals "Status code is success instead of failure."
}

function can_print_custom_message_for_failure_status_code_assertion() {
	message="$(assertion__status_code_is_failure 0 "custom message")"

  local expected="Status code is success instead of failure. custom message"
	_assert_message_equals "${expected}"
}

function asserting_that_successful_command_is_successful_is_true() {
	message="$(assertion__successful _successful_command)"

	_assert_success
	_assert_message_empty
}

function arguments_are_provided_for_successful_assertion() {
	message="$(assertion__successful \
    _successful_command_for_2_arguments "first" "second")"

	_assert_success
	_assert_message_empty
}

function arguments_with_spaces_are_provided_for_successful_assertion() {
	message="$(assertion__successful \
	  _successful_command_for_2_arguments "first argument" "second argument")"

	_assert_success
	_assert_message_empty
}

function asserting_that_failing_command_is_successful_is_false() {
	message="$(assertion__successful _failing_command)"

	_assert_failure
	_assert_message_equals "Command is failing instead of successful."
}

function asserting_that_failing_command_is_failing_is_true() {
	message="$(assertion__failing _failing_command)"

	_assert_success
	_assert_message_empty
}

function arguments_with_spaces_are_provided_for_failing_assertion() {
	message="$(assertion__failing \
    _failing_command_for_2_arguments "first argument" "second argument")"

	_assert_success
	_assert_message_empty
}

function asserting_that_successful_command_is_failing_is_false() {
	message="$(assertion__failing _successful_command)"

	_assert_failure
	_assert_message_equals "Command is successful instead of failing."
}

function asserting_that_equal_objects_are_equal_is_true() {
	message="$(assertion__equal equal equal)"

	_assert_success
	_assert_message_empty
}

function asserting_that_different_objects_are_equal_is_false() {
	message="$(assertion__equal equal different)"

	_assert_failure
	_assert_message_equals "Actual: <different>, expected: <equal>."
}

function asserting_that_different_objects_are_different_is_true() {
	message="$(assertion__different equal different)"

	_assert_success
	_assert_message_empty
}

function asserting_that_equal_objects_are_different_is_false() {
	message="$(assertion__different equal equal)"

	_assert_failure
	_assert_message_equals "Both values are: <equal>."
}

function asserting_that_string_contains_substring_is_true() {
 	message="$(assertion__string_contains string tri)"

	_assert_success
	_assert_message_empty
}

function asserting_that_string_contains_different_string_is_false() {
 	message="$(assertion__string_contains string z)"

	_assert_failure
	_assert_message_equals "String: <string> does not contain: <z>."
}

function asserting_that_string_does_not_contain_different_string_is_true() {
 	message="$(assertion__string_does_not_contain string z)"

	_assert_success
	_assert_message_empty
}

function asserting_that_string_does_not_contain_substring_is_false() {
 	message="$(assertion__string_does_not_contain string tri)"

	_assert_failure
	_assert_message_equals "String: <string> contains: <tri>."
}

function asserting_that_empty_string_is_empty_is_true() {
 	message="$(assertion__string_empty "")"

	_assert_success
	_assert_message_empty
}

function asserting_that_not_empty_string_is_empty_is_false() {
 	message="$(assertion__string_empty "not empty")"

	_assert_failure
	_assert_message_equals "String: <not empty> is not empty."
}

function asserting_that_not_empty_string_is_not_empty_is_true() {
 	message="$(assertion__string_not_empty "not empty")"

	_assert_success
	_assert_message_empty
}

function asserting_that_empty_string_is_not_empty_is_false() {
 	message="$(assertion__string_not_empty "")"

	_assert_failure
	_assert_message_equals "The string is empty."
}

function asserting_that_array_contains_contained_element_is_true() {
	local array=("a" "the element" "c")

 	message="$(assertion__array_contains "the element" "${array[@]}")"

	_assert_success
	_assert_message_empty
}

function asserting_that_array_contains_not_contained_element_is_false() {
 	local array=("a" "the element" "c")

 	message="$(assertion__array_contains "other element" "${array[@]}")"

	_assert_failure
	local expected="Array: <[a, the element, c]> does not contain: \
<other element>."
	_assert_message_equals "${expected}"
}

function asserting_that_array_does_not_contain_not_contained_element_is_true() {
 	local array=("a" "b" "c")

 	message="$(assertion__array_does_not_contain "z" "${array[@]}")"

	_assert_success
	_assert_message_empty
}

function asserting_that_array_does_not_contain_contained_element_is_false() {
 	local array=("a" "the element" "c")

 	message="$(assertion__array_does_not_contain "the element" "${array[@]}")"

	_assert_failure
	_assert_message_equals "Array: <[a, the element, c]> contains: <the element>."
}


function _successful_command() {
	return 0
}

function _successful_command_for_2_arguments() {
	(( $# == 2 ))
}

function _failing_command_for_2_arguments() {
	(( $# != 2 ))
}

function _failing_command() {
	return 1
}

function _assert_success() {
    (( $? == 0 )) || exit 1
}

function _assert_failure() {
    (( $? != 0 )) || exit 1
}

function _assert_message_empty() {
	[[ -z "${message}" ]] || exit 1
}

function _assert_message_equals() {
  [[ "${message}" == "Assertion failed. $1" ]] || exit 1
}