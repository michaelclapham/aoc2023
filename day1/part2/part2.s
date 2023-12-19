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

copyLoop:
    ldr	x0, =inputBuffer // set x0 to inputBuffer start address
    ldrb w5, [x0], #1 // load character / byte from address at x0 and increment x0 to address of next character
    ldr x1, =outputBuffer // set x1 to outputBuffer start address
    strb w5, [x1], #1 // store character to address at x1 and increment x1 to address of next character
    cmp	w5, #0 // check if character is null character
	beq end // end if character isn't null
    b copyLoop // loop otherwise

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
