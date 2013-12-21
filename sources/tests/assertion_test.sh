function assertingThatSuccessfulCommandHasSuccessStatusCodeIsTrue() {
	_succesfulCommand

	( assertion::assertStatusCodeIsSuccess $? > /dev/null )

	_assertSuccess
}

function assertingThatFailingCommandHasSuccessStatusCodeIsFalse() {
	_failingCommand

	( assertion::assertStatusCodeIsSuccess $? > /dev/null )

	_assertFailure
}

function assertingThatFailingCommandHasFailureStatusCodeIsTrue() {
	_failingCommand

	( assertion::assertStatusCodeIsFailure $? > /dev/null )

	_assertSuccess
}

function assertingThatSuccessfulCommandHasFailureStatusCodeIsFalse() {
	_succesfulCommand

	( assertion::assertStatusCodeIsFailure $? > /dev/null )

	_assertFailure
}

function assertingThatEqualObjectsAreEqualIsTrue() {
	( assertion::assertEqual equal equal > /dev/null )

	_assertSuccess
}

function assertingThatDifferentObjectsAreEqualIsFalse() {
	( assertion::assertEqual equal different > /dev/null )

	_assertFailure
}

function assertingThatStringContainsSubstringIsTrue() {
 	( assertion::assertStringContains string tri > /dev/null )

	_assertSuccess
}

function assertingThatStringContainsTotallyDifferentStringIsFalse() {
 	( assertion::assertStringContains string z > /dev/null )

	_assertFailure
}

function assertingThatStringDoesNotContainTotallyDifferentStringIsTrue() {
 	( assertion::assertStringDoesNotContain string z > /dev/null )

	_assertSuccess
}

function assertingThatStringDoesNotContainSubstringIsFalse() {
 	( assertion::assertStringDoesNotContain string tri > /dev/null )

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