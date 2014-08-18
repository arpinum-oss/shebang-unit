function my_test_function() {
  helper__function_called "${FUNCNAME}"
}

function your_test_function() {
  helper__function_called "${FUNCNAME}"
}

function my_other_test_function() {
  helper__function_called "${FUNCNAME}"
}