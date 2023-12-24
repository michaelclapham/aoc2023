/* file io linux constants */
.equ	O_RDONLY, 0
.equ	O_WRONLY, 1
.equ	O_CREAT,  0100
.equ	S_RDWR,   0666
.equ	AT_FDCWD, -100

/* buffer size */
.equ	BUFFER_SIZE, 92

.data

/* Data segment: define our message string and calculate its length. */
msg:
    .ascii "Hello, ARM!\n"
len = . - msg

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
    .ascii "./sample_input.txt"

inputBuffer:
    .fill BUFFER_SIZE + 1, 1, 0

outputBuffer:
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

    mov x11, x0 // save file handle

    /* syscall read */
    mov x0, x11 // file descriptor for input
    ldr x1, =inputBuffer
    mov x2, BUFFER_SIZE
    mov x8, #63
    svc 0

    /* syscall write */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, msg
    mov x2, #12 /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    /* input address */
    ldr	x0, =inputBuffer // set x0 to inputBuffer start address

    /* output address */
    ldr x6, =outputBuffer // set x6 to outputBuffer start address

    mov x2, #0 // x2 is the look ahead offset. reset to zero

//.macro checkNum, numStr, startLabel, loopLabel, nextLabel, replaceLabel, replaceChar, replaceLen

/* attempted macro before I gave up because macro syntax isn't great at combining strings */

/*
.macro checkNum, num, replaceChar, replaceLen

start_\num:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_\num:
    ldr	x1, =\num_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_\num
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_\num
    add x2, x2, #1 // increment offset
    b loop_\num

replace_\num:
    mov w3, \replaceChar
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, \replaceLen
    b loopFooter

end_\num:
    mov x0, x0 // no op

.endm

checkNum one, #49, #3
checkNum two, #50, #3
checkNum, three, #51, #5
checkNum, four, #52, #4
checkNum, five, #53, #4
checkNum, six, #54, #3
checkNum, seven, #55, #5
checkNum, eight, #56, #5
checkNum, nine, #57, #4

*/

/* I used javascript to do a "macro" instead

var checkNum = (num, i) => `

start_${num}:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_${num}:
    ldr	x1, =${num}_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_${num}
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_${num}
    add x2, x2, #1 // increment offset
    b loop_${num}

replace_${num}:
    mov w3, #${i + 48} // ${i + 48} is ascii for ${i}
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #${num.length}
    b loopFooter

end_${num}:
    mov x0, x0 // no op 
    `
var numStrs = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
for (var i = 0; i < 9; i++) {
    console.log(checkNum(numStrs[i], i + 1));
}

 */

start_one:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_one:
    ldr	x1, =one_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_one
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_one
    add x2, x2, #1 // increment offset
    b loop_one

replace_one:
    mov w3, #49 // 49 is ascii for 1
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #3
    b loopFooter

end_one:
    mov x0, x0 // no op 
    

start_two:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_two:
    ldr	x1, =two_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_two
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_two
    add x2, x2, #1 // increment offset
    b loop_two

replace_two:
    mov w3, #50 // 50 is ascii for 2
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #3
    b loopFooter

end_two:
    mov x0, x0 // no op 
    

start_three:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_three:
    ldr	x1, =three_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_three
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_three
    add x2, x2, #1 // increment offset
    b loop_three

replace_three:
    mov w3, #51 // 51 is ascii for 3
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #5
    b loopFooter

end_three:
    mov x0, x0 // no op 
    

start_four:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_four:
    ldr	x1, =four_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_four
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_four
    add x2, x2, #1 // increment offset
    b loop_four

replace_four:
    mov w3, #52 // 52 is ascii for 4
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #4
    b loopFooter

end_four:
    mov x0, x0 // no op 
    

start_five:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_five:
    ldr	x1, =five_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_five
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_five
    add x2, x2, #1 // increment offset
    b loop_five

replace_five:
    mov w3, #53 // 53 is ascii for 5
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #4
    b loopFooter

end_five:
    mov x0, x0 // no op 
    

start_six:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_six:
    ldr	x1, =six_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_six
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_six
    add x2, x2, #1 // increment offset
    b loop_six

replace_six:
    mov w3, #54 // 54 is ascii for 6
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #3
    b loopFooter

end_six:
    mov x0, x0 // no op 
    

start_seven:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_seven:
    ldr	x1, =seven_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_seven
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_seven
    add x2, x2, #1 // increment offset
    b loop_seven

replace_seven:
    mov w3, #55 // 55 is ascii for 7
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #5
    b loopFooter

end_seven:
    mov x0, x0 // no op 
    

start_eight:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_eight:
    ldr	x1, =eight_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_eight
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_eight
    add x2, x2, #1 // increment offset
    b loop_eight

replace_eight:
    mov w3, #56 // 56 is ascii for 8
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #5
    b loopFooter

end_eight:
    mov x0, x0 // no op 
    

start_nine:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

loop_nine:
    ldr	x1, =nine_str // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replace_nine
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne end_nine
    add x2, x2, #1 // increment offset
    b loop_nine

replace_nine:
    mov w3, #57 // 57 is ascii for 9
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, #4
    b loopFooter

end_nine:
    mov x0, x0 // no op 

noNumber:
    strb w3, [x0] // store character at w5 to address at x0 register (output pointer)
    add x0, x0, #1 // increment input pointer by 1 character

loopFooter:
    // Stop looping if loop counter higher than buffer size
    cmp x2, #BUFFER_SIZE
    bgt end

    cmp	w5, #0 // check if character is null character
	beq end // end if character isn't null
    b start_one // continue checking and replacing

end:

    /* write to std-out the outputBuffer (which should be the same as file just read in) */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    ldr x1, =outputBuffer
    mov x2, BUFFER_SIZE /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    //fsync syscall
    mov x0, x11 // holds input file handle
    mov x8, #82 // syscall 92 = fsync
    svc 0

    //close syscall
    mov x0, x11 // holds input file handle
    mov x8, #57 // syscall 57 = close
    svc 0

exit_prog:

    /* syscall exit(int status) */
    mov x0, #42 /* exit value is 42 */
    mov x8, #93 /* syscall 93 = exit */
    svc #0
