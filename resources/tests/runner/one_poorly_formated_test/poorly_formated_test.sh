function well_formated_test_function() {
  helper__function_called "${FUNCNAME}"
}

  function indented_test_function() {
    helper__function_called "${FUNCNAME}"
  }

function inlined_test_function() { helper__function_called "${FUNCNAME}"; };

#function commented_test_function() {
#    helper__function_called "${FUNCNAME}"
#}

    #function commented_test_function_indented() {
    #    helper__function_called "${FUNCNAME}"
    #}