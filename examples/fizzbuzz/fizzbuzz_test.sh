#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/fizzbuzz.sh"

function global_setup() {
  _enumeration=($(fizzbuzz__enumerate))
}

function fizzbuzz_should_enumerate_100_elements() {
  assertion__equal 100 ${#_enumeration[@]}
}

function fizzbuzz_should_enumerate_fizz_for_3() {
  assertion__equal "Fizz" "$(_get_value_for_number 3)"
}

function fizzbuzz_should_enumerate_fizz_for_all_multiples_of_3() {
  assertion__equal "Fizz" "$(_get_value_for_number 6)"
}

function fizzbuzz_should_enumerate_buzz_for_5() {
  assertion__equal "Buzz" "$(_get_value_for_number 5)"
}

function fizzbuzz_should_enumerate_buzz_for_15() {
  assertion__equal "FizzBuzz" "$(_get_value_for_number 15)"
}

function _get_value_for_number() {
  local array_index=$(($1 - 1))
  printf "${_enumeration[${array_index}]}"
}