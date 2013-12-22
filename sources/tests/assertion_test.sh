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
 	message="$( assertion::string_contains string tri)"

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

function _assert_success() {
    return $( (( $? == 0 )) )
}

function _assert_failure() {
    return $( (( $? != 0 )) )
}

function _succesful_command() {
	return 0
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