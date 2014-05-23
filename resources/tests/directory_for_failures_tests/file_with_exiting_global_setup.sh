function global_setup() {
	_function_called "${FUNCNAME}"
	exit 1
}

function test_function() {
	_function_called "${FUNCNAME}"
}

function global_teardown() {
	_function_called "${FUNCNAME}"
}