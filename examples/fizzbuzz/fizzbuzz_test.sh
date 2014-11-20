#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/fizzbuzz.sh"

function global_setup() {
  _enumeration=($(fizzbuzz__enumerate))
}

function fizzbuzz_should_enumerate_100_elements() {
  assertion__equal 100 ${#_enumeration[@]}
}

function fizzbuzz_should_enumerate_fizz_for_3() {
  _assert_value_for_number 3 "Fizz"
}

function fizzbuzz_should_enumerate_fizz_for_all_multiples_of_3() {
  _assert_value_for_number 6 "Fizz"
}

function fizzbuzz_should_enumerate_buzz_for_5() {
  _assert_value_for_number 5 "Buzz"
}

function fizzbuzz_should_enumerate_buzz_for_15() {
  _assert_value_for_number 15 "FizzBuzz"
}

function _assert_value_for_number() {
  assertion__equal "$2" "$(_get_value_for_number $1)"
}

function _get_value_for_number() {
  local array_index=$(($1 - 1))
  printf "${_enumeration[${array_index}]}"
}