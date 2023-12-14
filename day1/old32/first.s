extern printf

section .data
    startMsg DB "Start message",10,0
    newLineMsg DB "new line!",10,0
    digitMsg DB "digit!",10,0
    firstDigitMsg DB "first digit!",10,0
    secondDigitMsg DB "second digit!",10,0
    loopFmt DB "loop iteration %c",10,0

    pathname DD "../sample_input.txt"

    loopCounter DD 0

    digitsOnLine DD 0
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
    MOV ecx, 0
    MOV [loopCounter], ecx
loop1:
    MOV ecx, [loopCounter]
    MOV edx, [buffer + ecx] ; ecx is now the current character in the string

    ; Print the character we're on
    PUSH edx
    PUSH loopFmt
    CALL printf
    MOV edx, 0

check_for_newline:
    MOV ecx, [loopCounter]
    MOV dl, [buffer + ecx] ; dl is now the current character in the string
    ; dl is 8 bit register which we are using to compare against ASCII numbers
    
    ; check if we are on a new line
    CMP dl, 10
    JE onNewLine

check_for_digit:
    CMP dl, 48
    JLE loopEnd ; if <= 48 then not a digit, end loop

    CMP dl, 57 ; if >= 57 then not a digit, end loop
    JGE loopEnd

    JMP onDigit

onDigit:
    MOV ecx, [digitsOnLine]
    CMP ecx, 0 ; now check value before incrementing
    JE onFirstDigit ; if = 1 then first digit
    JMP onSecondDigit ; else second digit

onFirstDigit:
    MOV ecx, [digitsOnLine]
    INC ecx
    MOV [digitsOnLine], ecx
    MOV ecx, 0

    PUSH firstDigitMsg
    CALL printf

    
    JMP loopEnd

onSecondDigit:
    PUSH secondDigitMsg
    CALL printf
    JMP loopEnd

onNewLine:
    PUSH newLineMsg
    CALL printf

    MOV ecx, 0
    MOV [digitsOnLine], ecx

    JMP loopEnd

loopEnd:
    MOV ecx, [loopCounter] ; move loop counter into edx so we can increment it
    INC ecx
    MOV [loopCounter], ecx ; write incremented edx back into loop counter
    CMP ecx,42 ; finish loop if loop counter >= 42
    JGE end
    JMP loop1

end:
    ; Exit the program
    MOV eax,1
    MOV ebx,1
    INT 80h