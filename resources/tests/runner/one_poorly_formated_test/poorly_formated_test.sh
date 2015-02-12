posix_function() {
  helper__function_called "${FUNCNAME}"
}

posix_function_with_space_before_parenthesis () {
  helper__function_called "${FUNCNAME}"
}

  indented_posix_function() {
    helper__function_called "${FUNCNAME}"
  }

function ksh_function() {
  helper__function_called "${FUNCNAME}"
}

function ksh_function_without_brace {
  helper__function_called "${FUNCNAME}"
}

function ksh_function_with_space_before_parenthesis () {
  helper__function_called "${FUNCNAME}"
}

  function ksh_posix_function() {
    helper__function_called "${FUNCNAME}"
  }

#function commented_test_function() {
#    helper__function_called "${FUNCNAME}"
#}

    #function commented_test_function_indented() {
    #    helper__function_called "${FUNCNAME}"
    #}
