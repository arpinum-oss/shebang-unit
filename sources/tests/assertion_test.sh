function setup() {
	message=""
}

function asserting_that_successful_command_has_success_status_code_is_true() {
	_succesful_command

	message="$(assertion::status_code_is_success $?)"

	_assert_success
	_assert_message_empty
}

function asserting_that_failing_command_has_success_status_code_is_false() {
	_failing_command

	message="$(assertion::status_code_is_success $?)"

	_assert_failure
	_assert_message_equals "Status code is failure instead of success."
}

function when_asserting_status_code_is_success_a_custom_message_can_be_printed() {
	_failing_command

	message="$(assertion::status_code_is_success $? "custom message")"

	_assert_message_equals "Status code is failure instead of success. custom message"
}

function asserting_that_failing_command_has_failure_status_code_is_true() {
	_failing_command

	message="$(assertion::status_code_is_failure $?)"

	_assert_success
	_assert_message_empty
}

function asserting_that_successful_command_has_failure_status_code_is_false() {
	_succesful_command

	message="$(assertion::status_code_is_failure $?)"

	_assert_failure
	_assert_message_equals "Status code is success instead of failure."
}

function when_asserting_status_code_is_failure_a_custom_message_can_be_printed() {
	_succesful_command

	message="$(assertion::status_code_is_failure $? "custom message")"

	_assert_message_equals "Status code is success instead of failure. custom message"
}

function asserting_that_successful_command_is_successful_is_true() {
	message="$(assertion::successful _succesful_command)"

	_assert_success
	_assert_message_empty
}

function when_asserting_that_command_is_successful_the_arguments_are_provided() {
	message="$(assertion::successful _succesful_command_if_two_arguments_are_provided "first" "second")"

	_assert_success
	_assert_message_empty
}

function when_asserting_that_command_is_successful_the_arguments_are_provided_though_they_have_spaces() {
	message="$(assertion::successful _succesful_command_if_two_arguments_are_provided "first argument" "second argument")"

	_assert_success
	_assert_message_empty
}

function asserting_that_failing_command_is_successful_is_false() {
	message="$(assertion::successful _failing_command)"

	_assert_failure
	_assert_message_equals "Command is failing instead of successful."
}

function asserting_that_failing_command_is_failing_is_true() {
	message="$(assertion::failing _failing_command)"

	_assert_success
	_assert_message_empty
}

function when_asserting_that_command_is_failing_the_arguments_are_provided_though_they_have_spaces() {
	message="$(assertion::failing _failing_command_if_two_arguments_are_provided "first argument" "second argument")"

	_assert_success
	_assert_message_empty
}

function asserting_that_successful_command_is_failing_is_false() {
	message="$(assertion::failing _succesful_command)"

	_assert_failure
	_assert_message_equals "Command is successful instead of failing."
}

function asserting_that_equal_objects_are_equal_is_true() {
	message="$(assertion::equal equal equal)"

	_assert_success
	_assert_message_empty
}

function asserting_that_different_objects_are_equal_is_false() {
	message="$(assertion::equal equal different)"

	_assert_failure
	_assert_message_equals "Actual: <different>, expected: <equal>."
}

function asserting_that_string_contains_substring_is_true() {
 	message="$(assertion::string_contains string tri)"

	_assert_success
	_assert_message_empty
}

function asserting_that_string_contains_totally_different_string_is_false() {
 	message="$(assertion::string_contains string z)"

	_assert_failure
	_assert_message_equals "String: <string> does not contain: <z>."
}

function asserting_that_string_does_not_contain_totally_different_string_is_true() {
 	message="$(assertion::string_does_not_contain string z)"

	_assert_success
	_assert_message_empty
}

function asserting_that_string_does_not_contain_substring_is_false() {
 	message="$(assertion::string_does_not_contain string tri)"

	_assert_failure
	_assert_message_equals "String: <string> contains: <tri>."
}

function asserting_that_array_contains_contained_element_is_true() {
	local array=("a" "the element" "c")

 	message="$(assertion::array_contains "the element" "${array[@]}")"

	_assert_success
	_assert_message_empty
}

function asserting_that_array_contains_not_contained_element_is_false() {
 	local array=("a" "the element" "c")

 	message="$(assertion::array_contains "other element" "${array[@]}")"

	_assert_failure
	_assert_message_equals "Array: <[a, the element, c]> does not contain: <other element>."
}

function asserting_that_array_does_not_contain_not_contained_element_is_true() {
 	local array=("a" "b" "c")

 	message="$(assertion::array_does_not_contains "z" "${array[@]}")"

	_assert_success
	_assert_message_empty
}

function asserting_that_array_does_not_contain_contained_element_is_false() {
 	local array=("a" "the element" "c")

 	message="$(assertion::array_does_not_contains "the element" "${array[@]}")"

	_assert_failure
	_assert_message_equals "Array: <[a, the element, c]> contains: <the element>."
}

function _assert_success() {
    return $( (( $? == 0 )) )
}

function _assert_failure() {
    return $( (( $? != 0 )) )
}

function _succesful_command() {
	return 0
}

function _succesful_command_if_two_arguments_are_provided() {
	(( $# == 2 ))
}

function _failing_command_if_two_arguments_are_provided() {
	(( $# != 2 ))
}

function _failing_command() {
	return 1
}

function _assert_message_empty() {
	assertion::equal "" "${message}"
}

function _assert_message_equals() {
	assertion::equal "Assertion failed. ${1}" "${message}"
}