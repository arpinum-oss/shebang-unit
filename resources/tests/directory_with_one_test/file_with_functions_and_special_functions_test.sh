function global_setup() {
	_function_called "${FUNCNAME}"
}

function global_teardown() {
	_function_called "${FUNCNAME}"
}

function setup() {
	_function_called "${FUNCNAME}"
}

function teardown() {
	_function_called "${FUNCNAME}"
}

function first_test_function() {
	_function_called "${FUNCNAME}"
}

function second_test_function() {
	_function_called "${FUNCNAME}"
}

function _private_not_called_function() {
	_function_called "${FUNCNAME}"
}