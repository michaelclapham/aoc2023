extern printf
extern exit

section .data
    loopFmt DB "loop iteration %i",10,0
    fmt DB "Input is:",10,"%s",10,0
    pathname DD "./input.txt"
    list DB 1,2,3,4
section .bss
    buffer: resb 64
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
    MOV edx,64
    INT 80h

    ; Print test message
    PUSH buffer
    PUSH fmt
    CALL printf

    ; Test loop
    MOV eax, 0
loop1:
    PUSH eax
    PUSH loopFmt
    CALL printf
    INC eax
    CMP eax,3
    JGE end
    JMP loop1

end:
    ; Exit the program
    MOV eax,1
    MOV ebx,1
    INT 80h