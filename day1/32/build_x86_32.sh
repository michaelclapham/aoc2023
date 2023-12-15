#!/bin/bash
# Create 32 bit executable

# When not using external C functions can use below
#nasm -f elf -o first.o first.s
#ld -m elf_i386 -o first first.o

# Using external C functions so need to link using GCC

# This required installing
# sudo apt-get install gcc gcc-multilib
# gcc-multilib is requried for compiling 32 bit on 64 bit machine

nasm -f elf32 -o part1.o part1.s

gcc -no-pie -m32 part1.o -o part1

chmod a+x ./part1
