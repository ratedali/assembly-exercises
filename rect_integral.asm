    section     .data
file:           db      "C:\Users\ratedali\Documents\FunctionOfX.txt",0
mode:           db      "r",0
format:         db      "%lf %lf",0
outformat:      db      "R = %f",0
file_no:        dd      0
x:              dq      0
x_prev:         dq      0
f:              dq      0
integral:       dq      0 
    section     .text
    global      _main
    extern      _fopen, _fclose, _fscanf, _printf
_main:
    push        ebp
    mov         ebp, esp
    push        mode
    push        file
    call        _fopen
    mov         [file_no], eax
    push        f
    push        x_prev
    push        format
    push        dword [file_no]
    call        _fscanf
    finit
    fldz
_loop:
    push        f
    push        x
    push        format
    push        dword [file_no]
    call        _fscanf
    cmp         eax, -1
    jz          _eof
    fld         qword [x]
    fsub        qword [x_prev]
    fld         qword [f]
    fmulp
    faddp
    mov         eax, [x]
    mov         [x_prev], eax
    mov         eax, [x+4]
    mov         [x_prev+4], eax
    jmp         _loop
_eof:
    fstp        qword [integral]
    push        dword [integral+4]
    push        dword [integral]
    push        outformat
    call        _printf
    xor         eax, eax
    leave
    ret