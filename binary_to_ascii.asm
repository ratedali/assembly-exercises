    section     .data
Num     db      191
_str    db      0
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    xor         eax, eax
    mov         al, [Num]
    mov         ecx, 8
conv_loop:
    mov         ebx, 0x0f00
    mov         edx, 0xf000
    mov         esi, 0x0f0000
    and         ebx, eax
    shr         ebx, 8
    cmp         ebx, 5
    jl          cmp_tens
    add         eax, 0x0300
cmp_tens:
    and         edx, eax
    shr         edx, 12
    cmp         edx, 5
    jl          cmp_hundreds
    add         eax, 0x3000
cmp_hundreds:
    and         esi, eax
    shr         esi, 16
    cmp         esi, 5
    jl          next_iter
    add         eax, 0x030000
next_iter:
    shl         eax, 1
    dec         ecx
    jnz         conv_loop
    mov         edx, eax
    and         eax, 0x0f0000
    shr         eax, 16
    add         eax, 0x30
    mov         [_str], al
    mov         eax, edx
    and         eax, 0xf000
    shr         eax, 12
    add         eax, 0x30
    mov         [_str+1], al
    mov         eax, edx
    and         eax, 0x0f00
    shr         eax, 8
    add         eax, 0x30
    mov         [_str+2], al
    mov         byte [_str+3], 0
    xor         eax, eax
    leave
    ret