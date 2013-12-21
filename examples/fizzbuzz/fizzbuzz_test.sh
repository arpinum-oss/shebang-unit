#!/bin/bash

_TEST_DIRECTORY="$(dirname ${BASH_SOURCE[0]})"

source "${_TEST_DIRECTORY}/../../releases/shebang_unit.sh"
source "${_TEST_DIRECTORY}/fizzbuzz.sh"

_enumeration=()

function setup() {
	_enumeration=($(fizzbuzz_enumerate))
}

function fizzbuzzShouldEnumerate100Elements() {
	assertion::assertEqual 100 ${#_enumeration[@]}
}

function fizzbuzzShouldEnumerateFizzFor3() {
	assertion::assertEqual "Fizz" "$(_getResultForNumber 3)"
}

function fizzbuzzShouldEnumerateFizzForAllMultiplesOf3() {
	assertion::assertEqual "Fizz" "$(_getResultForNumber 6)"
}

function fizzbuzzShouldEnumerateBuzzFor5() {
	assertion::assertEqual "Buzz" "$(_getResultForNumber 5)"
}

function fizzbuzzShouldEnumerateBuzzFor15() {
	assertion::assertEqual "FizzBuzz" "$(_getResultForNumber 15)"
}

function _getResultForNumber() {
	local arrayIndex=$(($1 - 1))
	printf "${_enumeration[${arrayIndex}]}"
}

runner::runAllTestFilesInDirectory "${_TEST_DIRECTORY}" $@
