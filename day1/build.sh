#!/bin/bash
# Create 32 bit executable

# When not using external C functions can use below
#nasm -f elf -o first.o first.s
#ld -m elf_i386 -o first first.o

# Using external C functions so need to link using GCC

# This required installing
# sudo apt-get install gcc gcc-multilib
# gcc-multilib is requried for compiling 32 bit on 64 bit machine

nasm -f elf32 -o first.o first.s

gcc -no-pie -m32 first.o -o first

chmod a+x ./first
