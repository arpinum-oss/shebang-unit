function setup() {
	helper__function_called "${FUNCNAME}"
	exit 1
}

function test_function() {
	helper__function_called "${FUNCNAME}"
}

function teardown() {
	helper__function_called "${FUNCNAME}"
}