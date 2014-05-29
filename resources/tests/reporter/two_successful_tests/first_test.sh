function first_successful_test_function() {
	printf "some log\n"
	printf "some error log\n" >&2
}

function second_successful_test_function() {
	:
}