my_test_function() {
  helper__function_called "${FUNCNAME}"
}

your_test_function() {
  helper__function_called "${FUNCNAME}"
}

my_other_test_function() {
  helper__function_called "${FUNCNAME}"
}
