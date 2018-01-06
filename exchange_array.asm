    section     .data
array:          dd      1,2,3,4,5,6,7,8
len:            dd      ($-array)/4

    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    test        dword [len], 0x1
    jz          exchange
    dec         dword [len]
exchange:
    xor         ecx, ecx
xchg_loop:
    mov         eax, [array+ecx*4]
    xchg        eax, [array+ecx*4+4]
    mov         [array+ecx*4], eax
    add         ecx, 2
    cmp         ecx, dword [len]
    jl          xchg_loop
    xor         eax, eax
    leave
    ret