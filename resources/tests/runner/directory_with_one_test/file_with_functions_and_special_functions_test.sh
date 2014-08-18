function global_setup() {
  helper__function_called "${FUNCNAME}"
}

function global_teardown() {
  helper__function_called "${FUNCNAME}"
}

function setup() {
  helper__function_called "${FUNCNAME}"
}

function teardown() {
  helper__function_called "${FUNCNAME}"
}

function first_test_function() {
  helper__function_called "${FUNCNAME}"
}

function second_test_function() {
  helper__function_called "${FUNCNAME}"
}

function _private_not_called_function() {
  helper__function_called "${FUNCNAME}"
}