fizzbuzz__enumerate() {
  local i
  for i in {1..100}; do
    printf "%s " "$(_fizzbuzz__get_value_for_number ${i})"
  done
}

_fizzbuzz__get_value_for_number() {
  local number=$1
  local result="$(_fizzbuzz__print_value_if_multiple "Fizz" ${number} 3)"
  result+="$(_fizzbuzz__print_value_if_multiple "Buzz" ${number} 5)"
  _fizzbuzz__print_value_of_default_if_empty "${result}" ${number}
}

_fizzbuzz__print_value_if_multiple() {
  local value=$1; local number=$2; local divisor=$3
  _fizzbuzz__number_is_multiple ${number} ${divisor} \
    && printf "${value}" \
    || printf ""
}

_fizzbuzz__number_is_multiple() {
  (( $1 % $2 == 0 ))
}

_fizzbuzz__print_value_of_default_if_empty() {
  local value=$1; local default=$2
  [[ -n "${value}" ]] \
    && printf "${value}" \
    || printf "${default}"
}
