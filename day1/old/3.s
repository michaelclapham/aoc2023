extern printf
extern exit

section .data
    fmt DB "Input is:",10,"%s",10,0
    pathname DD "./input.txt"
section .bss
    buffer: resb 1024
section .text

global main

main:
    ; Open file
    MOV eax,5
    MOV ebx,pathname
    MOV ecx,0
    INT 80h

    ; Read file into buffer
    MOV ebx,eax
    MOV eax,3
    MOV ecx,buffer
    MOV edx,1024
    INT 80h

    ; Print test message
    PUSH buffer
    PUSH fmt
    CALL printf

    ; Exit the program
    PUSH 1
    CALL exit