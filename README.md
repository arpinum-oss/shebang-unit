# Shebang unit #

> Bang bang, my baby shot me down.
> <cite>(Cher)</cite>

**Shebang Unit** is an automated testing framework for Bash 4 based on [xUnit].

With **Shebang Unit** you can :
 * assert equality,
 * assert that string contains or not another string,
 * assert that array contains or not an element,
 * assert that status code is success or failure,
 * assert that command is successful or failing,
 * save a baby kitten every time you use it!

## Serious examples ##

### Basic equality for newbies ###

```bash
function can_assert_equality() {
  assertion__equal 4 $((3+1))
}
```

### Awesome string assertions ###

```bash
function can_assert_that_string_contains_another_one() {
  assertion__string_contains "Cool dog is cool" "cool"
}
```

```bash
function can_assert_that_string_does_not_contain_another_one() {
  assertion__string_does_not_contain "Monorail cat" "Caturday"
}
```

```bash
function can_assert_that_string_is_empty() {
  assertion__string_empty ""
}
```

```bash
function can_assert_that_string_is_not_empty() {
  assertion__string_not_empty "Don't feed the zombies"
}
```

### Rocket science array assertions ###

```bash
function can_assert_that_array_contains_element() {
  local lost_numbers=(4 8 15 16 23 42)

  assertion__array_contains 15 "${lost_numbers[@]}"
}
```

```bash
function can_assert_that_array_does_not_contain_element() {
  local lost_numbers=(4 8 15 16 23 42)

  assertion__array_does_not_contain 1337 "${lost_numbers[@]}"
}
```

### Magic command assertions ###

```bash
function can_assert_that_status_code_is_success() {
  true

  assertion__status_code_is_success $?
}
```

```bash
function can_assert_that_status_code_is_success() {
  false

  assertion__status_code_is_failure $?
}
```

```bash
function can_assert_that_command_is_successful() {
  assertion__successful true
}
```

```bash
function can_assert_that_command_is_failing() {
  assertion__failing false
}
```

## Usage ##

todo

## License ##

Copyright (C) 2013, Arpinum

**Shebang Unit** is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

**Shebang Unit** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with **Shebang Unit**.  If not, see [http://www.gnu.org/licenses/lgpl.html].


[xUnit]: http://wikipedia.org/wiki/XUnit
[http://www.gnu.org/licenses/lgpl.html]: http://www.gnu.org/licenses/lgpl.html