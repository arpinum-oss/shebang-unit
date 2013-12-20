function assertingThatSuccessfulCommandHasSuccessStatusCodeIsTrue() {
	_succesfulCommand

	( assertStatusCodeIsSuccess $? > /dev/null )

	_assertSuccess
}

function assertingThatFailingCommandHasSuccessStatusCodeIsFalse() {
	_failingCommand

	( assertStatusCodeIsSuccess $? > /dev/null )

	_assertFailure
}

function assertingThatFailingCommandHasFailureStatusCodeIsTrue() {
	_failingCommand

	( assertStatusCodeIsFailure $? > /dev/null )

	_assertSuccess
}

function assertingThatSuccessfulCommandHasFailureStatusCodeIsFalse() {
	_succesfulCommand

	( assertStatusCodeIsFailure $? > /dev/null )

	_assertFailure
}

function assertingThatEqualObjectsAreEqualIsTrue() {
	( assertEqual equal equal > /dev/null )

	_assertSuccess
}

function assertingThatDifferentObjectsAreEqualIsFalse() {
	( assertEqual equal different > /dev/null )

	_assertFailure
}

function assertingThatStringContainsSubstringIsTrue() {
 	( assertStringContains string tri > /dev/null )

	_assertSuccess
}

function assertingThatStringContainsTotallyDifferentStringIsFalse() {
 	( assertStringContains string z > /dev/null )

	_assertFailure
}

function assertingThatStringDoesNotContainTotallyDifferentStringIsTrue() {
 	( assertStringDoesNotContain string z > /dev/null )

	_assertSuccess
}

function assertingThatStringDoesNotContainSubstringIsFalse() {
 	( assertStringDoesNotContain string tri > /dev/null )

	_assertFailure
}

function _assertSuccess() {
    return $( (( $? == 0 )) )
}

function _assertFailure() {
    return $( (( $? != 0 )) )
}

function _succesfulCommand() {
	return 0
}

function _failingCommand() {
	return 1
}