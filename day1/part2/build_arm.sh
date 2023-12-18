#!/bin/bash

as -o part2.o part2.s
gcc -o part2 part2.o

chmod a+x ./part2