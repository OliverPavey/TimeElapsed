#!/usr/bin/env bash

if [[ "$OSTYPE" == "msys" ]]; then
    TIMEELAPSED_BINARY=./bin/windows/amd64/TimeElapsed.exe
else
    TIMEELAPSED_BINARY=./bin/linux/amd64/TimeElapsed
fi

FAILURES=0

runtest() {
    START=$1
    FINISH=$2
    EXPECTED=$3
    ACTUAL=$($TIMEELAPSED_BINARY $START $FINISH)
    if [[ $EXPECTED == $ACTUAL ]]; then
        echo "PASS: TimeElapsed '$START' '$FINISH' = '$EXPECTED'"
    else
        echo "FAIL: TimeElapsed '$START' '$FINISH' = '$ACTUAL' but should be '$EXPECTED'"
        FAILURES=$(($FAILURES + 1))
    fi
}

runtest '06:23:53.13_05/06/2024' '09:33:19.29_05/06/2024' 'Duration: 3h9m26.16s'
runtest '12:00:00.00_05/06/2024' '12:00:00.00_05/06/2024' 'Duration: 0s'
runtest '12:00:00.00_05/06/2024' '12:00:00.01_05/06/2024' 'Duration: 10ms'
runtest '12:00:00.00_05/06/2024' '12:00:01.00_05/06/2024' 'Duration: 1s'
runtest '12:00:00.00_05/06/2024' '12:01:00.00_05/06/2024' 'Duration: 1m0s'
runtest '12:00:00.00_05/06/2024' '13:00:00.00_05/06/2024' 'Duration: 1h0m0s'
runtest '12:00:00.00_05/06/2024' '12:00:00.00_06/06/2024' 'Duration: 24h0m0s'

if [[ $FAILURES == 0 ]]; then
    echo 'ALL PASSED.'
else
    echo "$FAILURES TESTS FAILED."
    exit 1
fi
