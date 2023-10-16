; Executable name: 	reverse exercise
; Last update:      2023-06-14
; Author:           Lukas Ith
; Description:      Reverses a string in memory and outputs it to stdout

; Build using the command:
;   make
; run it using:
;   ./reverse


section .data
    Input:      db "!sseccuS", 10   ; the input to reverse plus a newline (ASCII 10) at the end
    Length:     equ $ - Input       ; length of the string

section .bss
    Output:     resb Length         ; reserve memory to write the output to

section .text

global _start                       ; tell the compiler at which label our program starts

_start:
    
    ;
    ; <===== place your code here =====>
    ;

    ; write Output to stdout using a syscall
    mov rax, 1                      ; system call number for sys_write
    mov rdi, 1                      ; file descriptor: stdout
    mov rsi, Output                 ; output buffer
    mov rdx, Length                 ; number of bytes to write
    syscall

    ; terminate program
    mov rax, 60                     ; sys_exit
    mov rdi, 0                      ; success!
    syscall
