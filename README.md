# Michael Clapham - Advent of Code - 2023

I'm trying to do the advent of code here for 2023.

I'm trying to do each day in a different programming language, but we'll see how far I get...

# Day 1 

## Part 1
Trying x86 32 Assembly (on Ubuntu) using nasm

Rest of commands for part 1 `./day1/32/build_x86_32.sh`
Learning from this video: https://www.youtube.com/watch?v=IGo2ldg2Mp0&list=PL2EF13wm-hWCoj6tUBGUmrkJmH1972dBB&index=6

## Part 2
Trying ARM 64 Assembly (via Raspberry Pi debian via QEMU on Ubuntu) using as
Docs on how I setup QEMU are [here](./day1/part2/qemu_readme.md)

# Day 2

Using (free Pascal)

Install Free Pascal using `sudo apt-get install lazarus`

`fpc part1.pas -g && cat input.txt | ./part1` to build and run
