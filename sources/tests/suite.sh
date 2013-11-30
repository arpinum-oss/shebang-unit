#!/bin/bash

source ${0%/*}/../production/executor.sh

executor_executeAllTestFilesInDirectory ${0%/*} ${@}