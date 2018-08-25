#!/bin/bash

printf "\x55\xaa" | dd of=$1 bs=1 count=2 seek=510 conv=notrunc