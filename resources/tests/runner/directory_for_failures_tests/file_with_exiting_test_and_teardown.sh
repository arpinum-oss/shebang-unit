function teardown() {
	_function_called "${FUNCNAME}"
}

function failing_test_function() {
	_function_called "${FUNCNAME}"
	exit 1
}