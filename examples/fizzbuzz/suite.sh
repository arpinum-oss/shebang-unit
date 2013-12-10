#!/bin/bash

source ${0%/*}/../../sources/production/runner.sh

runner_runAllTestFilesInDirectory ${0%/*} ${@}