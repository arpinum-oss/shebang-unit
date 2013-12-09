#!/bin/bash

source ${0%/*}/../production/runner.sh

runner_runAllTestFilesInDirectory ${0%/*} ${@}