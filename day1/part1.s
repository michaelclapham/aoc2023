section .data
    helloMsg DB "Hello 64bit!",10,0
section .bss
    buffer: resb 100
section .text
    global main

main:   
    mov rax, 1 ; write system call
    mov rdi, 1 ; file handle 1 is stdout
    mov rsi, helloMsg
    mov rdx, 13 ; number of bytes in string
    syscall

    mov rax, 60 ; exit system call
    xor rdi, rdi ; same as mov rdi, 0 - for exit code 0
    syscall