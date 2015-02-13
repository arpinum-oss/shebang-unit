database__initialise() {
  _SBU_DB_TOKEN="$(system__random)"
  _database__ensure_directory_exists
}

database__release() {
  rm -rf "$(_database__get_dir)"
}

database__put() {
  _database__ensure_directory_exists
  system__print "$2" > "$(_database__get_dir)/$1"
}

database__post() {
  _database__ensure_directory_exists
  system__print "$2" >> "$(_database__get_dir)/$1"
}

database__post_line() {
  _database__ensure_directory_exists
  system__print_line "$2" >> "$(_database__get_dir)/$1"
}

database__put_variable() {
  _database__ensure_directory_exists
  database__put "$1" "${!1}"
}

database__get() {
  [[ -e "$(_database__get_dir)/$1" ]] && cat "$(_database__get_dir)/$1"
}

database__get_descriptor() {
  system__print "$(_database__get_dir)/$1"
}

_database__ensure_directory_exists() {
  mkdir -p "$(_database__get_dir)"
}

_database__get_dir() {
  system__print "${SBU_TEMP_DIR}/database/${_SBU_DB_TOKEN}"
}
