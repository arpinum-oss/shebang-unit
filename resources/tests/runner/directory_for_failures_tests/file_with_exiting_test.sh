function global_teardown() {
	helper__function_called "${FUNCNAME}"
}

function failing_test_function() {
	helper__function_called "${FUNCNAME}"
	exit 1
}