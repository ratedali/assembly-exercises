;   morse_code encodes an input string of uppercase letters and numbers using morse code (dots, dashes and spaces)
;   and prints the result
;   the output is assumed to not exceed 1024 characters

    section .data
characters:     db      '.-', 0x00, 0x00, '-...', '-.-.', '-..', 0x00,\
                        '.', 0x00, 0x00, 0x00, '..-.', '--.', 0x00, '....',\
                        '..', 0x00, 0x00, '.---', '-.-', 0x00, '.-..', \
                        '--', 0x00, 0x00, '-.', 0x00, 0x00, '---', 0x00, '.--.',\
                        '--.-', '.-.', 0x00, '...', 0x00, '-', 0x00, 0x00, 0x00,\
                        '..-', 0x00, '...-', '.--', 0x00, '-..-',\
                        '-.--', '--..'
numbers:        db      '-----', 0x00, 0x00, 0x00,\
                        '.----', 0x00, 0x00, 0x00,\
                        '..---', 0x00, 0x00, 0x00,\
                        '...--', 0x00, 0x00, 0x00,\
                        '....-', 0x00, 0x00, 0x00,\
                        '.....', 0x00, 0x00, 0x00,\
                        '-....', 0x00, 0x00, 0x00,\
                        '--...', 0x00, 0x00, 0x00,\
                        '---..', 0x00, 0x00, 0x00,\
                        '----.', 0x00, 0x00, 0x00
input:          db      'C0D3R', 0

    section     .bss
output:         resb      1024

    section     .text
    global      _main
    extern      _printf
_main:
    mov         ebp, esp
    mov         edi, output
    xor         eax, eax
    xor         ecx, ecx
_encode:
    mov         al, [input+ecx]
    cmp         al, 0
    jz          _done
    cmp         al, '9'
    jle         _number
    sub         al, 'A'
    mov         ebx, 4
    mov         esi, characters    
    jmp         _copy_code 
_number:
    sub         al, '0'
    mov         ebx, 8
    mov         esi, numbers
_copy_code:
    mul         ebx
    add         esi, eax
    push        ecx
    xor         ecx, ecx
_copy_loop:
    mov         al, [esi+ecx]
    cmp         al, 0
    jz          _next_iter
    mov         [edi+ecx], al
    inc         ecx
    cmp         ecx, ebx
    jl          _copy_loop
_next_iter:
    mov         byte [edi+ecx], ' '
    inc         ecx
    add         edi, ecx
    pop         ecx
    inc         ecx
    jmp         _encode
_done:
    mov         byte [edi], 0x00
    push        output
    call        _printf
    xor         eax, eax
    add         esp, 4
    ret