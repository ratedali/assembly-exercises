    section     .data
max:            dd          100
format:         db          "%d", 0x0a, 0
; using 1KB of memory for the sieve boolean array (see https://wikipedia.org/wiki/Sieve_of_Eratosthenes)
; each bit corresponds to one element. This has implications on the indexing
; the bit corresponding to an index n is the (0x7 & n) bit (counting from the MSB) on the (0xfffffff8 AND n)/8 byte
sieve_array:    times 1024  db 0xff
    section     .text
    global      _main
    extern      _printf
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    sub         esp, 16
m               equ 0           ; to hold the largest number whose multiples are to be removed: (SQRT n)
i               equ 4           ; to hold the value for the counter of the outer loop, which is also used as a step in the inner loop
    finit
    fild         dword [max]
    fsqrt
    fistp       dword [esp+m]
    mov         ecx, 2
_sieve_loop:
    cmp         ecx, [esp+m]
    jg          _done
    mov         eax, 0xfffffff8 ; byte index mask
    and         eax, ecx
    shr         eax, 3
    mov         al, [sieve_array+eax]
    push        ecx             ; save the value of ecx because it's needed for the shift operation
    and         ecx, 0x7
    shl         al, cl          ; shift the desired bit to be the MSB
    pop         ecx             ; restore ecx
    and         al, 0x80        ; get the MSB
    jz          _next_iter      ; if it's zero, then the number isn't prime, no need to remove its multiples
    mov         [esp+i], ecx    ; save the value of ecx because it's needed in the next loop
                                ; not using push/pop because it messes with esp
    shl         ecx, 1          ; go to the first multiple
_remove_multiples:
    mov         eax, 0xfffffff8
    and         eax, ecx        ; eax holds the index of the byte containing the boolean
    shr         eax, 3
    mov         dl, [sieve_array+eax]
    push        ecx             ; save the value of ecx because it's needed for the shift operation
    mov         bl, 0x80        ; the following lines generate the apropriate mask to set the bit to zero
    and         ecx, 0x7
    shr         bl, cl
    pop         ecx             ; restore ecx
    not         bl              ; bl now contains the mask where all bits are set to 1 except the desired bit
    and         dl, bl          ; set the apropriate bit to zero
    mov         [sieve_array+eax], dl
    add         ecx, [esp+i] ; go to the next multiple
    cmp         ecx, [max]
    jl          _remove_multiples
    mov         ecx, [esp+i]    ; restore the counter of the outer loop
_next_iter:
    inc         ecx
    jmp         _sieve_loop
_done:
    mov         ecx, 1
_translate_primes:
    mov         eax, 0xfffffff8 ; byte index mask
    and         eax, ecx
    shr         eax, 3
    mov         al, [sieve_array+eax]
    push        ecx             ; save the value of ecx because it's needed for the shift operation
    and         ecx, 0x7
    shl         al, cl          ; shift the desired bit to be the MSB
    pop         ecx             ; restore ecx
    and         al, 0x80        ; get the MSB
    jz          _trans_next_iter; if it's zero, then the number isn't prime, no need to remove its multiples
    push        ecx
    push        format
    call        _printf
    mov         ecx, [esp+4]     ; restore ecx
    add         esp, 8           ; restoring esp manually because there can be a large number of prime numbers
                                 ; this should avoid stack overflow issues
_trans_next_iter:
    inc         ecx
    cmp         ecx, [max]
    jl          _translate_primes
    xor         eax, eax
    leave
    ret