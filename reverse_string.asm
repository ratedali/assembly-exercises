    section     .data
src:            db          "string",0
len             equ         $-src-1
target:         db          0  
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         esi, src
    mov         edi, target
    add         edi, len
    mov         ecx, len
reverse_loop:
    mov         al, [esi]
    mov         [edi], al
    inc         esi
    dec         edi
    dec         ecx
    jg          reverse_loop
    xor         eax, eax
    leave
    ret