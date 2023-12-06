extern printf
extern exit

section .data
    msg DD "Hello World!",0
    msg2 DD "Hello... again",0
    fmt DB "Output is: %s %s",10,0
section .text

global main

main:
    PUSH msg2
    PUSH msg
    PUSH fmt
    CALL printf
    PUSH 1
    CALL exit