    section     .data
n               dd      16
base            dd      16
conv            db      0
    section     .text
    global      _main
_main:
    push        ebp
    mov         ebp, esp
    mov         eax, [n]
    xor         ecx, ecx
_div:
    xor         edx, edx
    div         dword [base]
    cmp         edx, 9
    jg          _chars
    add         dl, 0x30
    jmp         _push_char
_chars:
    sub         dl, 10
    add         dl, 0x41
_push_char:
    push        edx
    inc         ecx
    cmp         eax, 0
    jne         _div
    mov         ebx, ecx
    xor         ecx, ecx
_concat:
    pop         eax
    mov         [conv+ecx], al
    inc           ecx
    cmp         ecx, ebx
    jne         _concat
    xor         eax, eax
    leave
    ret