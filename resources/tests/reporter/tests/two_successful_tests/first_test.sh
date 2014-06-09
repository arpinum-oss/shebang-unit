printf "some log in the file\n"

function global_setup() {
	printf "some log in global setup\n"
}

function global_teardown() {
	printf "some log in global teardown\n"
}

function setup() {
	printf "some log in setup\n"
}

function teardown() {
	printf "some log in teardown\n"
}

function first_successful_test_function() {
	printf "some log in test\n"
	printf "some error log in test\n" >&2
}

function second_successful_test_function() {
  :
}
