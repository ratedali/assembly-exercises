    section     .data
array:          dd          1,2,3,4,5,6,7
len             equ         ($-array)/4
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         eax, [array]
    mov         ecx, 1
rotate_loop:
    xchg        eax, [array+ecx*4]
    inc         ecx
    cmp         ecx, len
    jl          rotate_loop
    xchg        eax, [array]
    xor         eax, eax
    leave
    ret