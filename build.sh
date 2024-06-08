#!/usr/bin/env bash

targets=("windows/386" "windows/amd64" "linux/386" "linux/amd64" "linux/arm" "linux/arm64")

for target in "${targets[@]}"; do
    split=(${target//\// })
    export GOOS=${split[0]}
    export GOARCH=${split[1]}
    
    mkdir -p bin/$GOOS/$GOARCH

    if [ $GOOS = 'windows' ]; 
    then EXT=.exe 
    else EXT= 
    fi
    OUTPUT='bin/'$GOOS'/'$GOARCH'/TimeElapsed'$EXT

    go build -o $OUTPUT
    
    echo bin/$GOOS/$GOARCH:
    ls -l bin/$GOOS/$GOARCH | tail -1
done
