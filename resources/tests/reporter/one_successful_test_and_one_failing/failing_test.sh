function successful_test_function() {
	printf "some log\n"
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
  printf "some log\n"
	assertion__equal 3 2
}