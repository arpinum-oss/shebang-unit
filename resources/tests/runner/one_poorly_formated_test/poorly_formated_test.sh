function well_formated_test_function() {
  _function_called "${FUNCNAME}"
}

  function indented_test_function() {
    _function_called "${FUNCNAME}"
  }

function inlined_test_function() { _function_called "${FUNCNAME}"; };

#function commented_test_function() {
#    _function_called "${FUNCNAME}"
#}

    #function commented_test_function_indented() {
    #    _function_called "${FUNCNAME}"
    #}