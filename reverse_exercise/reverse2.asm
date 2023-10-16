section .data
    input_string db "!ssecuS", 0       ; Input string
    output_string db 7 dup(0)           ; Output string buffer

section .text
    global _start

_start:
    ; Find the length of the input string
    mov ecx, 0
find_length:
    cmp byte [input_string + ecx], 0
    je  end_find_length
    inc ecx
    jmp find_length
end_find_length:

    ; Reverse the string
    mov esi, ecx              ; esi = length of the string
    dec esi                   ; Adjust esi to index the last character
    mov edi, 0                ; edi = index for output_string

reverse_loop:
    cmp esi, 0
    jl  end_reverse
    mov al, [input_string + esi]
    mov [output_string + edi], al
    inc edi
    dec esi
    jmp reverse_loop
end_reverse:

    ; Null-terminate the output string
    mov byte [output_string + edi], 0

    ; Print the reversed string
    mov eax, 4                 ; syscall: write
    mov ebx, 1                 ; file descriptor: STDOUT
    mov ecx, output_string     ; pointer to the string
    mov edx, edi               ; length of the string
    int 0x80                   ; call kernel

    ; Exit the program
    mov eax, 1                 ; syscall: exit
    xor ebx, ebx               ; exit code 0
    int 0x80                   ; call kernel

