#!/bin/bash
# Create 32 bit executable

nasm -f elf -o first.o first.s
ld -m elf_i386 -o first first.o
