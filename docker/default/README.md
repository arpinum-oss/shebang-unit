# shebang-unit

[shebang-unit] is an automated testing framework for Bash 4 based on [xUnit].

This image allows you to test your project in an isolated container.

## How to use this image

To run unit tests in your project:

    docker run --rm -v "$(pwd):/src" michaelborde/shebang-unit

You can pass arguments to *shebang-unit* with `SBU_OPTS` env variable.

Example with reporter and color options:

    docker run --rm -v "$(pwd):/src" -e SBU_OPTS="-r=dots -c=no" michaelborde/shebang-unit

## Lightweight image

Default image is based on ubuntu but you can also use the `light` tag based on Alpine. If your project is a pure Bash kata, the small set of binaries should work.


[shebang-unit]: https://github.com/arpinum/shebang-unit
[xUnit]: http://wikipedia.org/wiki/XUnit
