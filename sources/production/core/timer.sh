timer__store_current_time() {
  local id=$1
  database__put "sbu_beginning_date_$1" "$(system__get_date_in_seconds)"
}

timer__get_time_elapsed() {
  local id=$1
  local beginning_date="$(database__get "sbu_beginning_date_$1")"
  local ending_date="$(system__get_date_in_seconds)"

  [[ -n "${beginning_date}" ]] \
    && system__print "$(( ending_date - beginning_date ))" \
    || system__print "0"
}
