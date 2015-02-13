teardown() {
  helper__function_called "${FUNCNAME}"
}

failing_test_function() {
  helper__function_called "${FUNCNAME}"
  return 1
}
