extern printf

section .data
    startMsg DB "Start message",10,0
    newLineMsg DB "new line!",10,0
    digitMsg DB "digit!",10,0
    firstDigitMsg DB "first digit! %i",10,0
    otherDigitMsg DB "another digit! %i",10,0
    loopFmt DB "loop iteration %c",10,0
    resultForLineMsg DB "result for line %i",10,0
    totalMsg DB "total is %i",10,0

    pathname DD "../sample_input.txt"

    loopCounter DD 0

    digitsOnLine DD 0

    firstDigit DD 0
    lastDigit DD 0

    total DD 0
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
    ; put previous number of digits on line in ecx and eax
    ; increment eax and save it back to digitsOnLine
    MOV ecx, [digitsOnLine]
    MOV eax, ecx
    INC eax
    MOV [digitsOnLine], eax

    CMP ecx, 0 ; now check value before incrementing
    MOV ecx, 0 ; set registers back to zero to not cause problems downstream
    MOV eax, 0 ;
    JE onFirstDigit ; if = 1 then first digit
    JMP onOtherDigit ; else second digit

onFirstDigit:
    ; subtract 48 to get int value for character
    MOV ecx, [loopCounter]
    MOV dl, [buffer + ecx] ; dl is now the current character in the string
    MOV al, dl ; move into al so we can subtract from it
    SUB al, 48 ; after this al is an 8 bit integer of the digit
    MOVZX edx, al ; move into a 32 bit register so we can add to 32 bit total
    MOV ecx, [total] ; fetch existing total
    ADD ecx, edx ; add this digit to total ; todo: move this to onNewLine eventually
    MOV [total], ecx ; move new total back into memory

    PUSH edx
    PUSH firstDigitMsg
    CALL printf

    
    JMP loopEnd

onOtherDigit:
    ; subtract 48 to get int value for character
    MOV ecx, [loopCounter]
    MOV dl, [buffer + ecx] ; dl is now the current character in the string
    MOV al, dl ; move into al so we can subtract from it
    SUB al, 48 ; after this al is an 8 bit integer of the digit
    MOVZX edx, al ; move into a 32 bit register so we can add to 32 bit total
    MOV ecx, [total] ; fetch existing total
    ADD ecx, edx ; add this digit to total ; todo: move this to onNewLine eventually
    MOV [total], ecx ; move new total back into memory

    PUSH edx
    PUSH otherDigitMsg
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
    ; Print total 
    PUSH totalMsg
    CALL printf

    ; Exit the program
    MOV eax,1
    MOV ebx,1
    INT 80h