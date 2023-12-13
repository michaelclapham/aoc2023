extern printf

section .data
    startMsg DB "Start message",10,0
    newLineMsg DB "new line!",10,0
    digitMsg DB "digit!",10,0
    loopFmt DB "loop iteration %c",10,0
    fmt DB "Input is:",10,"%s",10,0
    pathname DD "../sample_input.txt"
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
    MOV edx,42
    INT 80h

    ; Print test message
    PUSH startMsg
    CALL printf

    ; Test loop
    MOV edx, 0
    MOV [loopCounter], edx
loop1:
    MOV edx, [loopCounter]
    MOV ecx, [buffer + edx] ; ecx is now the current character in the string

    ; Print the character we're on
    PUSH ecx
    PUSH loopFmt
    CALL printf

check_for_newline:
    MOV edx, [loopCounter]
    MOV dl, [buffer + edx] ; dl is now the current character in the string
    ; dl is 8 bit register which we are using to compare against ASCII numbers
    
    ; check if we are on a new line
    CMP dl, 10
    JE onNewLine

check_for_digit:
    CMP dl, 48
    JLE loopEnd

    CMP dl, 57
    JGE loopEnd

    JMP onDigit

onDigit:
    PUSH digitMsg
    CALL printf
    JMP loopEnd

onNewLine:
    PUSH newLineMsg
    CALL printf
    JMP loopEnd

loopEnd:
    MOV edx, [loopCounter] ; move loop counter into edx so we can increment it
    INC edx
    MOV [loopCounter], edx ; write incremented edx back into loop counter
    CMP edx,42 ; finish loop if loop counter >= 3
    JGE end
    JMP loop1

end:
    ; Exit the program
    MOV eax,1
    MOV ebx,1
    INT 80h