    section     .data
array:          dd      1,2,3,4,5,6,7
len             equ      ($-array)/4
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         esi, array              ; esi points to the first element
    mov         edi, array+(len-1)*4    ; edi points to the last element
    mov         ecx, len
    shr         ecx, 1                  ; ecx has the number of exchanges to make: floor(n/2)
_reverse_loop:
    mov         eax, [esi]              ; exchange elements at esi and edi
    xchg        eax, [edi]
    mov         [esi], eax
    add         esi, 4                  ; advance both esi and edi in the correct direction
    sub         edi, 4
    dec         ecx
    jnz        _reverse_loop
    xor         eax, eax
    leave
    ret