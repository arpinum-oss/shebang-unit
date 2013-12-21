function asserting_that_successful_command_has_success_status_code_is_true() {
	_succesful_command

	( assertion::status_code_is_success $? > /dev/null )

	_assert_success
}

function asserting_that_failing_command_has_success_status_code_is_false() {
	_failing_command

	( assertion::status_code_is_success $? > /dev/null )

	_assert_failure
}

function asserting_that_failing_command_has_failure_status_code_is_true() {
	_failing_command

	( assertion::status_code_is_failure $? > /dev/null )

	_assert_success
}

function asserting_that_successful_command_has_failure_status_code_is_false() {
	_succesful_command

	( assertion::status_code_is_failure $? > /dev/null )

	_assert_failure
}

function asserting_that_equal_objects_are_equal_is_true() {
	( assertion::equal equal equal > /dev/null )

	_assert_success
}

function asserting_that_different_objects_are_equal_is_false() {
	( assertion::equal equal different > /dev/null )

	_assert_failure
}

function asserting_that_string_contains_substring_is_true() {
 	( assertion::string_contains string tri > /dev/null )

	_assert_success
}

function asserting_that_string_contains_totally_different_string_is_false() {
 	( assertion::string_contains string z > /dev/null )

	_assert_failure
}

function asserting_that_string_does_not_contain_totally_different_string_is_true() {
 	( assertion::string_does_not_contain string z > /dev/null )

	_assert_success
}

function asserting_that_string_does_not_contain_substring_is_false() {
 	( assertion::string_does_not_contain string tri > /dev/null )

	_assert_failure
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