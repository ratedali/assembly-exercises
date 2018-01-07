    section     .data
array:          dd      1,2,3,4,5,6
nbytes          equ     $-array
parity_even:    db      "Even!",0
parity_odd:     db      "Odd!",0
    section     .text
    global      _main
    extern      _printf
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         esi, array
    xor         ecx, ecx
    xor         eax, eax
xor_loop:                               ; uses the fact that the parity of (a XOR b) is the same as (a CONCAT b)
    xor         al, byte [esi+ecx]
    inc         ecx
    cmp         ecx, nbytes
    jl          xor_loop
    mov         esi, parity_even
    mov         edi, parity_odd
    xor         al, 0                   ; al XOR 0 = al, used to check the parity of al
    cmovp       eax, esi
    cmovnp      eax, edi
    push        eax
    call        _printf
    xor         eax, eax
    leave
    ret