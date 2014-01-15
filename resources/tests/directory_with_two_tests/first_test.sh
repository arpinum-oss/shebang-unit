function successful_test_function() {
	:
}

  function successful_test_function_indented() {
    :
  }

#function commented_test_function() {
#    :
#}

    #function commented_test_function_indented() {
    #    :
    #}

function failing_test_function() {
	assertion::equal 3 2
}