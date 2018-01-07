    section     .data
n               dd      20
format          db      "fib(%d) = %d",0
    section     .text
    global      _main
    extern      _printf
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    mov         eax, 1
    mov         ebx, 1
    cmp         dword [n], 3
    jl          done
    mov         ecx, 2
fib:
    mov         edx, eax
    add         eax, ebx
    mov         ebx, edx
    inc         ecx
    cmp         ecx, dword [n]
    jl          fib
done:
    push        eax
    push        dword [n]
    push        format
    call        _printf
    xor         eax, eax
    leave
    ret