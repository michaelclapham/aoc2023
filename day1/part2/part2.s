.data

/* Data segment: define our message string and calculate its length. */
msg:
    .ascii "Hello, ARM!\n"
len = . - msg

.text

/* Our application's entry point. */
.global main

main:

    /* syscall write */
    mov x0, #1 /* file descriptor 1 = standard out = console */
    adr x1, msg
    mov x2, #12 /* Number of bytes / characters in ascii string */
    mov x8, #64 /* syscall 64 = write */
    svc #0

    /* syscall exit(int status) */
    mov x0, #42 /* exit value is 42 */
    mov x8, #93 /* syscall 93 = exit */
    svc #0
