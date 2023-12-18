.data

/* Data segment: define our message string and calculate its length. */
msg:
    .ascii "Hello, ARM!\n"
len = . - msg

.text

/* Our application's entry point. */
.global main

main:
    /* syscall exit(int status) */
    mov x0, #42 /* exit value is 42 */
    mov x8, #93
    svc #0
