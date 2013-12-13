#!/bin/bash

_TEST_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

source "${_TEST_DIRECTORY}/../../releases/ShebangUnit.sh"
source "${_TEST_DIRECTORY}/fizzbuzz.sh"

function fizzbuzzShouldEnumerate100Elements() {
	local result=($(fizzbuzz_enumerate))

	assertEqual 100 ${#result[@]}
}

function fizzbuzzShouldEnumerateFizzFor3() {
	local result=($(fizzbuzz_enumerate))

	assertEqual "Fizz" "${result[2]}"
}

function fizzbuzzShouldEnumerateFizzForAllMultiplesOf3() {
	local result=($(fizzbuzz_enumerate))

	assertEqual "Fizz" "${result[5]}"
}

function fizzbuzzShouldEnumerateBuzzFor5() {
	local result=($(fizzbuzz_enumerate))

	assertEqual "Buzz" "${result[4]}"
}

function fizzbuzzShouldEnumerateBuzzFor15() {
	local result=($(fizzbuzz_enumerate))

	assertEqual "FizzBuzz" "${result[14]}"
}

runner_runAllTestFilesInDirectory "${_TEST_DIRECTORY}" ${@}
