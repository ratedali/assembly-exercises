    section     .data
file:           db      "x2sinx.txt",0
mode:           db      "w+",0
file_no:        dd      0
x:              dq      0.0
res:            dq      0
format:         db      "%.5f %.5f", 0x0a, 0
step:           dq      0.1
count:          dd      63                      ; number of elements from 0 to 2*pi using a step of 0.1
    section     .text
    global      _main
    extern      _fprintf, _fopen, _fclose
_main:
    push        ebp
    mov         ebp, esp
    push        mode
    push        file
    call        _fopen
    mov         [file_no], eax
    finit
_loop:
    fld         qword [x]
    fmul        qword [x]
    fld         qword [x]
    fsin
    fmulp
    fstp        qword [res]
    push        dword [res+4]
    push        dword [res]
    push        dword [x+4]
    push        dword [x]
    push        format
    push        dword [file_no]
    call        _fprintf
    fld         qword [x]
    fadd        qword [step]
    fstp        qword [x]
    dec         dword [count]
    jnz         _loop
    push        dword [file_no]
    call        _fclose
    xor         eax, eax
    leave
    ret