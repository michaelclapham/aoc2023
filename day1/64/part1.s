section .data
    helloMsg DB "Hello 64bit!",10,0
    pathname DB "./sample_input.txt"
    fileHandle DQ 0
section .bss
    buffer: resb 42
section .text
    global main

main:   
    mov rax, 1 ; write system call
    mov rdi, 1 ; file handle 1 is stdout
    mov rsi, helloMsg
    mov rdx, 13 ; number of bytes in string
    syscall

    ; Open file
    mov rax, 0 ; 0 = sys_read
    mov rdi, pathname
    mov rsi, 0 ; read only mode
    syscall ; rax will now contain file handle number
    mov [fileHandle], rax

after_open: 

    ; Read file into buffer
    mov rax, 0 ; 0 = sys_read - Read from file
    mov rdi, [fileHandle]
    mov rsi, buffer
    mov rdx, 42 ; number of bytes to read
    syscall

    mov rax, 1 ; 1 = sys write - Write to file
    mov rdi, 1 ; file handle 1 is stdout
    mov rsi, buffer
    mov rdx, 42 ; number of bytes in string
    syscall

    mov rax, 3 ; 3 = sys close - Close file handle
    mov rdi, [fileHandle]
    syscall

    mov rax, 60 ; exit system call
    xor rdi, rdi ; same as mov rdi, 0 - for exit code 0
    syscall