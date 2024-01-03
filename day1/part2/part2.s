/* file io linux constants */
.equ	O_RDONLY, 0
.equ	O_WRONLY, 1
.equ	O_CREAT,  0100
.equ	S_RDWR,   0666
.equ	AT_FDCWD, -100

/* buffer size */
.equ	BUFFER_SIZE, 22462

// Define printf as an external function
.extern printf

/* Data segment. */
.data

lineTotal:
    .byte 0

total:
    .int 0

oneStr:
    .asciz "one"

twoStr:
    .asciz "two"

threeStr:
    .asciz "three"

fourStr:
    .asciz "four"

fiveStr:
    .asciz "five"

sixStr:
    .asciz "six"

sevenStr:
    .asciz "seven"

eightStr:
    .asciz "eight"

nineStr:
    .asciz "nine"

totalMsgFormat:
    .asciz "%d \n"

inputFilename:
    .ascii "../input.txt"

inputBuffer:
    .fill BUFFER_SIZE + 1, 1, 0

.text

/* Our application's entry point. */
.global main

main:

    /* syscall openat */
	mov x0, #AT_FDCWD // allows opening relative to current directory
    ldr x1, =inputFilename
    mov x2, #O_RDONLY
	mov x3, #S_RDWR // mode param
    mov x8, #56
    svc 0

    mov x11, x0 // save file handle so we can close it after reading

    /* syscall read */
    mov x0, x11 // file descriptor for input
    ldr x1, =inputBuffer
    mov x2, BUFFER_SIZE
    mov x8, #63
    svc 0

    mov x9, x0 // save x0 for later 

    // fsync syscall
    mov x0, x11 // holds input file handle
    mov x8, #82 // syscall 92 = fsync
    svc 0

    // close syscall
    mov x0, x11 // holds input file handle
    mov x8, #57 // syscall 57 = close
    svc 0

    // syscall write input buffer to std out
    //mov x0, #1 /* file descriptor 1 = standard out = console */
    //adr x1, inputBuffer
    //mov x2, x9 /* Number of bytes / characters in ascii string */
    //mov x8, #64 /* syscall 64 = write */
    //svc #0

/*
    From this point forward
    x3 - (lower 2 bytes) used for current character
    x5 - used for number of digits found on line
    x6 - used for first digit found
    x7 - used for second digit found
    x10 - used for input pointer
    x11 - used for final total
 */


setupRegisters:
    // input address
    ldr	x10, =inputBuffer // set x10 to inputBuffer start address
    mov x11, #0
    mov x3, #0 // set x3 to zero so that all bits are zero
    mov x5, #0
    mov x6, #0
    mov x7, #0 

checkForNewLine:
    ldrb w3, [x10] // load input at x10 into w3
    cmp w3, #10 // check if new line character
    beq onNewLine

checkForDigit:
    ldrb w3, [x10] // load input at x10 into w3
    cmp w3, #57 // ascii 57 = 9.
    bgt matchStringNumbers // if greater than '9', not a digit
    cmp w3, #48 // ascii 48 = 0
    blt matchStringNumbers // if less than '0', not a digit
    b onDigit 

// Macro for looking for string numbers starting at input pointer

.macro matchNum, numStr, startLabel, loopLabel, foundLabel, endLabel, intValue

\startLabel:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

\loopLabel:
    ldr	x1, =\numStr // set x0 to number string start address
    ldrb w3, [x10, x2] // load input + x2 offset into w3
    ldrb w4, [x1, x2] // load number string + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq \foundLabel // we have and therefore have found a match!
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne \endLabel
    add x2, x2, #1 // increment offset
    b \loopLabel

\foundLabel:
    mov w3, \intValue // move int value into w3 e.g 0
    add w3, w3, #48 // add 48 to int value to get ascii character
    b onDigit

\endLabel:
    mov x0, x0 // no op

.endm

/* Here we call the macro 9 times to generate assembly that
matches each string digit 'one', 'two', 'three' etc.

I generated these lines using some javascript
var output = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].map((n, i) => {
    return (`matchNum ${n}Str, ${n}_start, ${n}_loop, ${n}_found, ${n}_end, #${i+1}`)
}).join("\n")
console.log(output)

*/

matchStringNumbers: 

matchNum oneStr, one_start, one_loop, one_found, one_end, #1
matchNum twoStr, two_start, two_loop, two_found, two_end, #2
matchNum threeStr, three_start, three_loop, three_found, three_end, #3
matchNum fourStr, four_start, four_loop, four_found, four_end, #4
matchNum fiveStr, five_start, five_loop, five_found, five_end, #5
matchNum sixStr, six_start, six_loop, six_found, six_end, #6
matchNum sevenStr, seven_start, seven_loop, seven_found, seven_end, #7
matchNum eightStr, eight_start, eight_loop, eight_found, eight_end, #8
matchNum nineStr, nine_start, nine_loop, nine_found, nine_end, #9

notADigit:
    b nextChar

onDigit:
    sub w3, w3, #48 // minus 48 from w3 to get integer digit
    add x5, x5, #1 // increase number of digits found on the line
    cmp x5, #1
    beq onFirstDigit // if x5 = 1 then this is first digit on the line
    b onOtherDigit

onFirstDigit:
    mov w6, w3
    b nextChar

onOtherDigit:
    mov w7, w3
    b nextChar


onNewLine:
    cmp x5, #1
    beq onOneDigitLine
    b onMultiDigitLine
    
// From this point forward x2 is line total
onOneDigitLine:
    mov x0, #11
    mul x2, x6, x0 // x2 = x6 (first digit) * x0 (11)
    b addToTotal

onMultiDigitLine:
    mov x0, #10
    mul x2, x6, x0 // x9 = x6 (first digit) * x0 (10)
    add x2, x2, x7 // x14 = x14 + x13 (first digit * 10 + second digit) 

addToTotal:
    ldr	x0, =total // load address of total into x0
    //ldr x1, [x0] // load value at x0 (total) into x1
    add x11, x11, x2 // add x2 (line total) to x11 (final total)
    str x1, [x0] // store register x1 (total + line total) to address at x0 (total)

nextChar:
    add x10, x10, #1 // increment input pointer by 1 character
    mov x3, #0 // set x3 to zero so that all bits are zero
    ldrb w3, [x10] // load character at input pointer into w3
    cmp	w3, #0 // check if character is null terminator char
	beq exit_prog // end if character is null
    b checkForNewLine // else continue checking and replacing

exit_prog:
    //ldr	x0, =total // load address of total into x1
    //ldr x1, [x0] // load value at x0 (total) into x1
    mov x1, x11 // move x11 (final total) into x1 as it's 2nd arg of printf
    ldr x0, =totalMsgFormat // put address of totalMsgFormat into x0 register
    bl printf // calls printf(x0, x1) = printf (total, &totalMsgFormat)

exit_after_print:
    // syscall exit(int status)
    mov x0, #0
    mov x8, #93 // syscall 93 = exit
    svc #0
