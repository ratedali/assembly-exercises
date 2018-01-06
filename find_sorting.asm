    section .data   
numArray        dd 1,2,3,4,5
count           dd 4
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         ecx, 0
    xor         ebx, ebx
    mov         esi, 1
    mov         edi, -1
_find_sorting:
    mov         eax, [numArray + ecx*4]
    cmp         eax, [numArray + ecx*4 + 4]
    cmovl       ebx, esi
    cmovg       ebx, edi
    jne         _find_max
    inc         ecx
    jmp         _find_sorting
_find_max:
    xor         ecx, ecx
_cmp_loop:
    mov         eax, [numArray + ecx*4]
    mov         edx, [numArray + ecx*4 + 4]
    cmp         ebx, 0
    jl          _cmp_dec
    cmp         eax, edx
    jg          _not_sorted
    jmp         _next_iter
_cmp_dec:
    cmp         eax, edx
    jl          _not_sorted
_next_iter:
    inc         ecx
    cmp         ecx, [count]
    jne         _cmp_loop
    jmp         _done
_not_sorted:
    xor         ebx, ebx
_done:
    mov         eax, ebx
    leave
    ret