function can_make_function_do_nothing() {
  mock__make_function_do_nothing "_my_function"

  assertion__equal "" "$(_my_function)"
}

function can_make_function_prints_something() {
  mock__make_function_prints "_my_function" "something"

  assertion__equal "something" "$(_my_function)"
}

function can_make_function_call_another_one() {
  mock__make_function_call "_my_function" "printf message"

  assertion__equal "message" "$(_my_function)"
}

function _my_function() {
  printf "original code\n"
}