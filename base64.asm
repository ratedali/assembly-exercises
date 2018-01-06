                section .data
table           db      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/+",0
prompt          db      "Please enter a string of at most 1024 characters:",0x0a,0
nullprompt      db      "Input not given, using default string: '%s'", 0x0a, 0
resformat       db      "base64 of '%s' is '%s'", 0x0a,0
informat        db      "%s",0
defaultstr      db      "BA144043",0
defaultlen      dd      $-defaultstr

                section .bss
input           resb    1024
output          resb    1024

                section .text
                extern  _printf, _scanf
                global  _main
_main           push    ebp             ; for correct debugging
                mov     ebp, esp
                and     esp, 0xfffffff0; stack alignment
                sub     esp, 16
n               equ     0
padding         equ     4
                push    prompt          ; read input form user
                call    _printf                
                push    input
                push    informat
                call    _scanf
                cmp     byte [input], 0
                jne     base64_encode
use_defaultstr  push    defaultstr
                push    nullprompt
                call    _printf    
                mov     ecx, [defaultlen]
                mov     esi, defaultstr
                mov     edi, input
                cld
                rep     movsb
base64_encode   mov     ebx, table
                mov     esi, input
                mov     edi, output
divide_bytes    mov     ecx, 3
divide_loop     lodsb
                cmp     al, 0
                je      encode_bytes
                shl     eax, 8
                dec     ecx
                jz      encode_bytes
                jmp     divide_loop
encode_bytes    sub     ecx, 3          ; number of bytes read is 3 - $ecx
                neg     ecx
                jz      add_padding     ; if no bytes were read, add the padding (depending on the value of [esp+n])
                mov     [esp+n], ecx
                inc     ecx             ; number of characters to extract from an n bytes sequence is n+1
                mov     edx, eax        ; save data to edx
                mov     eax,[esp+n]
                cmp     eax, 1
                je      onebyte
                cmp     eax, 2
                je      twobytes
                jmp     encode_loop
twobytes        shl     edx, 8          ; to align with the 3 bytes case
                jmp     encode_loop
onebyte         shl     edx, 16         ; to align with the 3 and 2 bytes cases 
encode_loop     mov     eax, 0xFC000000
                and     eax, edx
                shr     eax, 26
                xlat
                mov     [edi], al
                inc     edi
                shl     edx, 6
                dec     ecx
                jnz     encode_loop
                jmp     divide_bytes

add_padding     xor     eax, eax        ; padding for three bytes: only null(0)
                mov     ecx, 0x3d       ; padding for two bytes: an equal sign(0x3d)
                mov     edx, 0x3d3d     ; padding for one byte: two equal signs
                cmp     dword [esp+n], 2
                cmove   eax, ecx
                cmp     dword [esp+n], 1
                cmove   eax, edx
                mov     dword [edi], eax
print           push    output
                call    _printf
                xor     eax, eax
                leave
                ret