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

oneStr:
    .ascii "one"

twoStr:
    .ascii "two"

threeStr:
    .ascii "three"

fourStr:
    .ascii "four"

fiveStr:
    .ascii "five"

sixStr:
    .ascii "six"

sevenStr:
    .ascii "seven"

eightStr:
    .ascii "eight"

nineStr:
    .ascii "nine"


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

.macro checkNum numStr, startLabel, loopLabel, nextLabel, replaceLabel, replaceChar, replaceLen

\startLabel:
    mov x2, #0 // x2 is the look ahead offset. reset to zero

\loopLabel:
    ldr	x1, =\numStr // set x1 to oneStr start address
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w4, #0 // check if we've reached end of string
    beq replaceLabel
    cmp w3, w4 // check if w3 (lookahead on input) equals w4 (number string + offset)
    bne \nextLabel
    add x2, x2, #1 // increment offset
    b \currentLabel

\replaceLabel:
    mov w3, \replaceChar
    strb w3, [x6] // store character at w5 to address at x6 register (output pointer)
    add x0, x0, \replaceLen
    b loopFooter
.endm

searchAndReplace:

checkNum oneStr checkOne loopOne checkTwo replaceOne #49 #3

checkNum twoStr checkTwo loopTwo checkThree replaceTwo #50 #3

checkNum threeStr checkThree loopThree checkFour replaceThree #51 #5

checkNum fourStr checkFour loopFour checkFive replaceFour #52 #4

checkNum fiveStr checkFive loopFive checkSix replaceFive #53 #4

checkNum sixStr checkSix loopSix checkSeven replaceSix #54 #3

checkNum sevenStr checkSeven loopSeven checkEight replaceSeven #55 #5

checkNum eightStr checkEight loopEight checkNine replaceEight #56 #5

checkNum nineStr checkNine loopNine loopFooter replaceNine #57 #4

noNumber:
    strb w3, [x0] // store character at w5 to address at x0 register (output pointer)
    mov x0, x0, #1 // increment input pointer by 1 character
    b loopFooter

/* checkOne:
    ldr	x1, =oneStr // set x1 to oneStr start address
    mov x2, #0 // x2 is the look ahead offset. reset to zero
    ldrb w3, [x0, x2] // load lookahead from input at x0 + x2 offset into w3
    ldrb w4, [x1, x2] // load number string from at x1 + x2 offset into w4
    cmp w3, w4 // check if w5 is 'o'
    bne checkTwo
    
    add x2, x2, #1 // increase lookahead by 1
    ldrb w5, [x0, x2] // load character / byte from address at x0 + x2 offset
    cmp w5, #119 // check if w6 is 'n'
    bne checkTwo

    add x4, x2, #2 // look to char at + x2 + 2
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 2 offset
    cmp w6, #101 // check if w6 is 'e'
    bne checkTwo
    
    // We found o,n,e
    // Increase input index by + 2 here
    // We always increase by + 1 in loopFooter
    // so 2 + 1 = length of 'one'
    add x2, x2, #2
    // Put '2' into current character register
    mov w5, #49 // ASCII 50 = '1'.
    b loopFooter

checkTwo:
    mov x4, x2 // x4 is look-ahead address
    // let's use w6 as the look-ahead char value
    cmp w5, #116 // check if w5 is 't'
    bne checkThree
    
    add x4, x2, #1 // look to char at + x2 + 1
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 1 offset
    cmp w6, #119 // check if w6 is 'w'
    bne checkThree

    add x4, x2, #2 // look to char at + x2 + 2
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 2 offset
    cmp w6, #111 // check if w6 is 'o'
    bne checkThree
    
    // We found t,w,o
    // Increase input index by + 2 here
    // We always increase by + 1 in loopFooter
    // so 2 + 1 = length of 'two'
    add x2, x2, #2
    // Put '2' into current character register
    mov w5, #50 // ASCII 50 = '2'.
    b loopFooter

checkThree:
    mov x4, x2 // x4 is look-ahead address
    // let's use w6 as the look-ahead char value
    cmp w5, #116 // check if w5 is 't'
    bne loopFooter
    
    add x4, x2, #1 // look to char at + x2 + 1
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 1 offset
    cmp w6, #104 // check if w6 is 'h'
    bne loopFooter

    add x4, x2, #2 // look to char at + x2 + 2
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 2 offset
    cmp w6, #114 // check if w6 is 'r'
    bne loopFooter

    add x4, x2, #3 // look to char at + x2 + 3
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 3 offset
    cmp w6, #101 // check if w6 is 'e'
    bne loopFooter


    add x4, x2, #4 // look to char at + x2 + 4
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 4 offset
    cmp w6, #101 // check if w6 is 'e'
    bne loopFooter
    
    // We found t,h,r,e,e
    // Increase input index by + 4 here
    // We always increase by + 1 in loopFooter
    // so 4 + 1 = length of 'three'
    add x2, x2, #4
    // Put '2' into current character register
    mov w5, #50 // ASCII 50 = '2'.
    b loopFooter

*/

loopFooter:
    // Stop looping if loop counter higher than buffer size
    cmp x2, #BUFFER_SIZE
    bgt end

    cmp	w5, #0 // check if character is null character
	beq end // end if character isn't null
    b searchAndReplace

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
