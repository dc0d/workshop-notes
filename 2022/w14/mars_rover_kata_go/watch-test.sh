#!/bin/sh

while true
do
    watchman-wait -p "**/*.go" -- .
    clear
    eval "go test -cover -count 1 ./..."
done
