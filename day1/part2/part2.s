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

    mov x2, #0 // input index
    mov x3, #0 // output index

loopHeader:
    ldr	x0, =inputBuffer // set x0 to inputBuffer start address
    ldrb w5, [x0, x2] // load character / byte from address at x0 + x2 offset
    
checkTwo:
    mov x4, x2 // x4 is look-ahead address
    // let's use w6 as the look-ahead char value
    cmp w5, #116 // check if w5 is 't'
    bne loopFooter
    
    add x4, x2, #1 // look to char at + x2 + 1
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 1 offset
    cmp w6, #116 // check if w6 is 'w'
    bne loopFooter

    add x4, x2, #2 // look to char at + x2 + 2
    ldrb w6, [x0, x4] // load character / byte from address at x0 + x2 + 2 offset
    cmp w6, #111 // check if w6 is 'o'
    bne loopFooter
    
    // We found t,w,o
    // Increase input index by + 2 here
    // We always increase by + 1 in loopFooter
    // so 2 + 1 = length of 'two'
    add x2, x2, #2
    // Put '2' into current character register
    mov w5, #50 // ASCII 50 = '2'.

loopFooter:
    ldr	x0, =inputBuffer // set x0 to inputBuffer start address
    ldrb w5, [x0, x2] // load character / byte from address at x0 + x2 offset
    // write x5 to output buffer at output offset (x3)
    ldr x1, =outputBuffer // set x1 to outputBuffer start address
    strb w5, [x1, x3] // store character at w5 to address at x1 + x3 offset

    // increment both input and output positions always
    add x2, x2, #1 // increment x2 by 1
    add x3, x3, #1 // increment x3 by 1

    // Stop looping if loop counter higher than buffer size
    cmp x2, #BUFFER_SIZE
    bgt end

    cmp	w5, #0 // check if character is null character
	beq end // end if character isn't null
    b loopHeader

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

    /* syscall exit(int status) */
    mov x0, #42 /* exit value is 42 */
    mov x8, #93 /* syscall 93 = exit */
    svc #0
