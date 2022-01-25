#!/bin/sh

while true
do
    watchman-wait -p "**/*.ex*" -- .
    clear
    make
done
