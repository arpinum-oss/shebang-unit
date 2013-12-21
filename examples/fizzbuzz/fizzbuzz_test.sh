#!/bin/bash

_TEST_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

source "${_TEST_DIRECTORY}/../../releases/shebang_unit.sh"
source "${_TEST_DIRECTORY}/fizzbuzz.sh"

_enumeration=()

function setup() {
	_enumeration=($(fizzbuzz_enumerate))
}

function fizzbuzz_should_enumerate_100_elements() {
	assertion::equal 100 ${#_enumeration[@]}
}

function fizzbuzz_should_enumerate_fizz_for_3() {
	assertion::equal "Fizz" "$(_get_result_for_number 3)"
}

function fizzbuzz_should_enumerate_fizz_for_all_multiples_of_3() {
	assertion::equal "Fizz" "$(_get_result_for_number 6)"
}

function fizzbuzz_should_enumerate_buzz_for_5() {
	assertion::equal "Buzz" "$(_get_result_for_number 5)"
}

function fizzbuzz_should_enumerate_buzz_for_15() {
	assertion::equal "FizzBuzz" "$(_get_result_for_number 15)"
}

function _get_result_for_number() {
	local array_index=$(($1 - 1))
	printf "${_enumeration[${array_index}]}"
}

runner::run_all_test_files_in_directory "${_TEST_DIRECTORY}" $@
