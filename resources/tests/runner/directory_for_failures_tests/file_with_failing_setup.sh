setup() {
  helper__function_called "${FUNCNAME}"
  return 1
}

test_function() {
  helper__function_called "${FUNCNAME}"
}

teardown() {
  helper__function_called "${FUNCNAME}"
}
