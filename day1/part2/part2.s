/* file io linux constants */
.equ	O_RDONLY, 0
.equ	O_WRONLY, 1
.equ	O_CREAT,  0100
.equ	S_RDWR,   0666
.equ	AT_FDCWD, -100

/* buffer size */
.equ	BUFFER_SIZE, 21462

/* Data segment. */
.data

// The final total
total:  
    .quad 0

inputPointer:  
    .quad 0

msg:
    .asciz "\n"
len = . - msg

finalTotalMsg:
    .asciz "Line total: "
finalTotalMsgLen = . - finalTotalMsg

lineTotalMsg:
    .asciz "Line total: "
lineTotalMsgLen = . - lineTotalMsg

foundDigitMsg:
    .asciz "Found digit: "
foundDigitMsgLen = . - foundDigitMsg

one_str:
    .asciz "one"

two_str:
    .asciz "two"

three_str:
    .asciz "three"

four_str:
    .asciz "four"

five_str:
    .asciz "five"

six_str:
    .asciz "six"

seven_str:
    .asciz "seven"

eight_str:
    .asciz "eight"

nine_str:
    .asciz "nine"


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

    //fsync syscall
    mov x0, x11 // holds input file handle
    mov x8, #82 // syscall 92 = fsync
    svc 0

    //close syscall
    mov x0, x11 // holds input file handle
    mov x8, #57 // syscall 57 = close
    svc 0

    /* syscall write */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, msg
    mov x2, #12 /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

/*
    From this point forward
    x0 - used for input pointer
    x11 - used for number of digits found on line
    x12 - used for first digit found
    x13 - used for second digit found
 */
setupRegisters:
    /* input address */
    ldr	x0, =inputBuffer // set x0 to inputBuffer start address
    str x0, =inputPointer // set input pointer to adress we just loaded into x0
    mov x11, #0
    mov x12, #0
    mov x13, #0 

checkForNewLine:
    ldrb w3, [x0] // load input at x0 into w3
    cmp w3, #10 // check if new line character
    beq onNewLine

checkForDigit:
    ldrb w3, [x0] // load input at x0 into w3
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
    ldr	x1, =\numStr // set x1 to number string start address
    ldrb w3, [x0, x2] // load input + x2 offset into w3
    ldrb w4, [x1, x2] // load number string + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq \foundLabel // we have and therefore have found a match!
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne \endLabel
    add x2, x2, #1 // increment offset
    b loop_\num

\foundLabel:
    mov w3, \intValue // move int value into w3 e.g 0
    add w3, w3, #48 // add 48 to int value to get ascii character
    b onDigit

\endLabel:
    mov x0, x0 // no op

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
    /* syscall write */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, foundDigitMsg
    mov x2, foundDigitMsgLen /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, x3
    mov x2, foundDigitMsgLen /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    sub w3, w3, #48 // minus 48 from w3 to get integer digit
    add x11, x11, #1 // increase number of digits found on the line
    cmp x11, #1
    beq onFirstDigit // if x11 = 1 then this is first digit on the line
    b onOtherDigit

onFirstDigit:
    mov x12, x3

onOtherDigit:
    mov x13, x3


onNewLine:
    cmp x11, #1
    beq onOneDigitLine
    b onMultiDigitLine
    
onOneDigitLine:
    mul x14, x12, #11
    b addToTotal

onMultiDigitLine:
    mul x14, x12, #10 // x14 = x12 (first digit) * 10
    add x14, x14, x13 // x14 += x13 (second digit)

addToTotal:
    ldr x15, =total
    add x15, x15, x14
    str x15, =total

nextChar:
    ldr x0, =inputPointer
    add x0, x0, #1 // increment input pointer by 1 character
    str x0, =inputPointer
    ldrb w3, [x0] // load character at input pointer into w3
    cmp	w3, #0 // check if character is null terminator char
	beq end // end if character is null
    b checkForNewLine // else continue checking and replacing

end:

    /* syscall write */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, lineTotalMsg
    mov x2, lineTotalMsgLen /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    /* write to std-out the outputBuffer (which should be the same as file just read in) */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    ldr x1, =outputBuffer
    mov x2, BUFFER_SIZE /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

exit_prog:

    /* syscall exit(int status) */
    mov x0, #42 /* exit value is 42 */
    mov x8, #93 /* syscall 93 = exit */
    svc #0
