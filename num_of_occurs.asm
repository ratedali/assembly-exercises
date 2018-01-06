    section     .data
s1:             db      "strstringstringstr",0
len1:           dd      $-s1-1
s2:             db      "str",0
len2:           dd      $-s2-1
format:         db      "'%s' occurs %d times in '%s'",0
    section     .text
    global      _main
    extern      _printf
_main:
    push        ebp
    mov         ebp, esp
    and         esp, 0xfffffff0
    xor         eax, eax            ; eax will hold the number of times s2 occurs in s1
    mov         ecx, [len2]         
    cmp         ecx, [len1]         
    jg          done                ; if s2 is longer than s1 then it cannot possibly occur in it
    mov         esi, s1
    xor         ebx, ebx            ; ebx will hold the number of s1 characters that have been compared against s2
find_occurs:
    mov         edi, s2
    mov         ecx, [len2]
    repz        cmpsb               ; compares until s2 has been exhausted (ecx = 0) or a mismatch occurs (ZF = 0)
    sub         edi, s2             ; edi now holds the number of s2 characters that have been compared against s1
    cmp         edi, [len2]
    jl          next_iter           ; if not all characters have been compared, then a mismatch must have occured
    inc         eax                 ; otherwise increment the number of s2 occurences since a full match was found
next_iter:
    add         ebx, edi            ; the number of s1 characters compared in this iteration is the same as the number of s2 characters
    cmp         ebx, [len1]
    jl         find_occurs          ; if not all of s1 has been compared, continue the operation
done:      
    push        s1
    push        eax
    push        s2
    push        format
    call        _printf
    xor         eax, eax
    leave
    ret