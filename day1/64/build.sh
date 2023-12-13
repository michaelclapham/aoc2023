#!/bin/bash

# Create 64 bit object file
nasm -f elf64 -o part1.o part1.s

# Link to create 64 bit executable file
# ld -m elf_x86_64 -o part1 part1.o

# Using GCC to link makes debugging with gdb easier
# Also allows calling external C functions if needed
# sudo apt-get install gcc gcc-multilib
gcc part1.o -o part1 -no-pie

chmod a+x ./part1
