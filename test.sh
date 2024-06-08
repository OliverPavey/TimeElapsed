#!/usr/bin/env bash
#export TIMEELAPSED_DEBUG=true

go run TimeElapsed.go '06:23:53.13_05/06/2024' '09:33:19.29_05/06/2024'

export start=$(date +%H:%M:%S.%2N_%d/%m/%Y)
sleep 1
export until=$(date +%H:%M:%S.%2N_%d/%m/%Y)

go run TimeElapsed.go "$start" "$until"