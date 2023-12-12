section .data
    startMsg DB "Start message",10,0
    newLineMsg DB "new line!",10,0
    loopFmt DB "loop iteration %c",10,0
    fmt DB "Input is:",10,"%s",10,0
    pathname DD "./input.txt"
    list DB 1,2,3,4
    loopCounter DB 0
section .bss
    buffer: resb 21464
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
    MOV edx,21464
    INT 80h

    ; Print test message
    PUSH startMsg
    CALL printf

    ; Test loop
    MOV eax, 0
    MOV [loopCounter], eax
loop1:
    MOV eax, [loopCounter]
    MOV ecx, [buffer + eax] ; ecx is now the current character in the string

    ; Print the character we're on
    PUSH ecx
    PUSH loopFmt
    CALL printf

loop_end:
    MOV eax, [loopCounter] ; move loop counter into eax so we can increment it
    INC eax
    MOV [loopCounter], eax ; write incremented eax back into loop counter
    CMP eax,3 ; finish loop if loop counter >= 3
    JGE end
    JMP loop1

end:
    ; Exit the program
    MOV eax,1
    MOV ebx,1
    INT 80h