global_setup() {
  helper__function_called "${FUNCNAME}"
}

global_teardown() {
  helper__function_called "${FUNCNAME}"
}

setup() {
  helper__function_called "${FUNCNAME}"
}

teardown() {
  helper__function_called "${FUNCNAME}"
}

first_test_function() {
  helper__function_called "${FUNCNAME}"
}

second_test_function() {
  helper__function_called "${FUNCNAME}"
}

_private_not_called_function() {
  helper__function_called "${FUNCNAME}"
}
