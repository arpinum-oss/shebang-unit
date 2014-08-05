# shebang_unit [![Etat build travis]](https://travis-ci.org/arpinum/shebang_unit) [![Etat build drone]](https://drone.io/github.com/arpinum/shebang_unit/latest)

> Bang bang, my baby shot me down.
> <cite>(Cher)</cite>

**shebang_unit** is an automated testing framework for Bash 4 based on [xUnit].

Just download it here : *[releases/shebang_unit]*. Write a kata like *[examples/fizzbuzz]* and have fun!

With **shebang_unit** you can :
 * assert equality,
 * assert that string contains or not another string,
 * assert that array contains or not an element,
 * assert that status code is success or failure,
 * assert that command is successful or failing,
 * write setup or teardown functions for a test or a whole test file,
 * mock functions to speed up tests or enhance reliability,
 * view tests results with different kind of reports,
 * randomly execute tests to verify isolation,
 * save a baby kitten every time you use it!

Now you don't have any excuse for not practicing some sexy Test-Driven Development in Bash.

## Serious examples

### Basic equality for newbies

```bash
function can_assert_equality() {
  assertion__equal 4 $((3+1))
}
```

### Awesome string assertions

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

### Rocket science array assertions

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

### Magic command assertions

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

### Mock in the Shell
> Your effort to remain what you are is what limits you.
> <cite>(Puppeteer, Ghost in the Shell)</cite>

```bash
function can_mock_pwd_to_do_nothing() {
  mock__make_function_do_nothing "pwd"

  assertion__equal "" "$(pwd)"
}
```

```bash
function can_mock_pwd_to_print_root() {
  mock__make_function_prints "pwd" "/"

  assertion__equal "/" "$(pwd)"
}
```

```bash
function can_mock_pwd_to_call_a_custom_function() {
  mock__make_function_call "pwd" "printf hello"

  assertion__equal "hello" "$(pwd)"
}
```

## Usage

1. Copy *[releases/shebang_unit]* wherever you want,
2. Create a file suffixed by *_test.sh* like *math_test.sh* in *your_folder*,
3. Write a test function like in previous examples,
4. Run `./shebang_unit your_folder`,
5. Write production code,
6. Refactor. Enough said.

### Use another reporter

You can use another reporter with `-r` or `--reporters` options.

`./shebang_unit --reporters=dots`

The default reporter is called *simple*. It writes a verbose logging of test run to standard output.

You can use its little brother, the *dots* reporter which only displays dots (successful), S (skipped) or F (failing). Such a lazy cat.

If you are a rock star you can try the über JUnit reporter in combination with your favorite CI server (Jenkins?).

Here we use the JUnit reporter plus the dots one to display some log in the console.

`./shebang_unit --reporters=dots,junit`

The JUnit reporter creates a *junit_report.xml* file in your working directory. You can define another file with :

`./shebang_unit --reporters=junit --output-file=/tmp/i_love_ponies.xml`

### Use colors or no

You can use colors in test outputs with `-c` or `--colors` options. Colors are activated by default.

`./shebang_unit --colors=no your_folder`

### Run test files and functions randomly or no

You can run test files and functions randomly with `-d` or `--random-run` options. Runs are sorted by default.

`./shebang_unit --random-run=yes your_folder`

Test files are alphabetically ordered and functions are ordered from top to bottom by default. If you select a random run, test files are randomized then inside a file, each functions are randomized.

### Use another test file pattern

Test file pattern can be changed with `-f` or `--file-pattern` options. It can be convenient to run only few tests or totally change the default pattern (`*_test.sh`).

`./shebang_unit --file-pattern=this_only_test.sh your_folder`

`./shebang_unit --file-pattern=test_*.sh your_folder`

### Use another test function pattern

Test function pattern can be changed with `-t` or `--test-pattern` options. The default is `*` and can be changed if you want to focus on a couple of tests only.

`./shebang_unit --test-pattern=can_compare* your_folder`

## Convention over configuration

**sheban_unit** doesn't need any annotation to recognise a test function. Just write un *public* (see below) function like :

```bash
function one_kitten_plus_another_is_equal_to_two_kittens() {
  ...
}

```

You can also use *private* functions to make your tests more explicit. Just prefix your functions by `_` :

```bash
function my_super_explicit_test_use_private_functions() {
  _arrange_the_mess
  
  _act_like_a_pro
  
  _assert_some_stuff
}

function _arrange_the_mess() {
  ...
}

...
```

### Build your own cathedral with setup or teardown functions

You can use special functions to arrange or clean the mess :

* `setup` : called before each test in a file
* `teardown` : called after each test in a file 
* `global_setup` : called once before all tests in a file
* `global_teardown` : called once after all tests in a file

## Pimp your **shebang_unit**

If you don't like **shebang_unit** coding conventions like function names or test file names, you can hack the global variables at the top of *shebang_unit.sh*.

For instance if your private functions are prefixed by `p_` for some reason :

```bash
SBU_PRIVATE_FUNCTION_NAME_REGEX="^p_.*"
```

Or, if you would rather live in dark and definitively turn off colors :

```bash
SBU_USE_COLORS="${SBU_NO}"
```


## License

Copyright (C) 2013, Arpinum

**shebang_unit** is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

**shebang_unit** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with **shebang_unit**.  If not, see [http://www.gnu.org/licenses/lgpl.html].


[Etat build travis]: https://travis-ci.org/arpinum/shebang_unit.png?branch=master
[Etat build drone]: https://drone.io/github.com/arpinum/shebang_unit/status.png
[xUnit]: http://wikipedia.org/wiki/XUnit
[releases/shebang_unit]: https://github.com/arpinum/shebang_unit/blob/master/releases/shebang_unit
[examples/fizzbuzz]: https://github.com/arpinum/shebang_unit/tree/master/examples/fizzbuzz
[http://www.gnu.org/licenses/lgpl.html]: http://www.gnu.org/licenses/lgpl.html
