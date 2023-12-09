section .data

section .text

global main

main:
    push 3
    push 2
    call sum
    add esp, 8 ; Clean up the stack by restoring the esp register (assuming two 4-byte parameters)
    jmp end

; Function: sum
; Parameters: a (4 bytes), b (4 bytes)
; Returns: eax = a + b
sum:
    push ebp          ; Save the old base pointer
    mov ebp, esp      ; Set the new base pointer

    mov eax, [ebp+8]  ; Load a from the stack
    add eax, [ebp+12] ; Add b to eax

    pop ebp           ; Restore the old base pointer
    ret 8             ; Return and clean up 8 bytes of parameters from the stack

end:
    mov ebx, eax ; Return eax as exit code
    mov eax, 1
    int 0x80