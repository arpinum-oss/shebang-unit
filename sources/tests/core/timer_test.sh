function setup() {
  database__initialise
}

function teardown() {
  database__release
}

function can_get_time_elapsed() {
  mock__make_function_prints "system__get_date_in_seconds" "12"
  timer__store_current_time "id"
  mock__make_function_prints "system__get_date_in_seconds" "38"

  local elapsed="$(timer__get_time_elapsed "id")"

  assertion__equal "26" "${elapsed}"
}

function can_get_time_elapsed_for_several_timers() {
  mock__make_function_prints "system__get_date_in_seconds" "10"
  timer__store_current_time "first_timer"

  mock__make_function_prints "system__get_date_in_seconds" "15"
  timer__store_current_time "second_timer"

  mock__make_function_prints "system__get_date_in_seconds" "20"
  local first_time_elapsed="$(timer__get_time_elapsed "first_timer")"

  mock__make_function_prints "system__get_date_in_seconds" "35"
  local second_time_elapsed="$(timer__get_time_elapsed "second_timer")"

  assertion__equal "10" "${first_time_elapsed}"
  assertion__equal "20" "${second_time_elapsed}"
}

function when_the_current_time_has_not_been_stored_the_elapsed_time_is_0() {
  mock__make_function_prints "system__get_date_in_seconds" "1337"

  local elapsed="$(timer__get_time_elapsed "id")"

  assertion__equal "0" "${elapsed}"
}