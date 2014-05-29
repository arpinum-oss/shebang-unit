function successful_test_function() {
	printf "some log\n"
}

function failing_test_function() {
  printf "some log\n"
	assertion__equal 3 2
}