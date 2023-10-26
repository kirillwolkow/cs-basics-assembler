;  Executable name : eatsyscall64
;  Version         : 1.0
;  Created date    : 08/30/2016
;  Last update     : 08/30/2016
;  Author          : Emmanuel Benoist
;  Description     : A simple program in assembly for Linux, using NASM,
;    demonstrating the use of Linux 64-bit syscalls to display text.
;
;  Build using these commands:
;    nasm -f elf64 -g -F dwarf eatsyscall64.asm
;    ld -o eatsyscall64 eatsyscall64.o

SECTION .data                     ; Section containing initialized data

    EatMsg: db "Eat at Joe's!",10
    EatLen: equ $-EatMsg          ; Compute the length of the string

SECTION .bss                      ; Section containing uninitialized data

SECTION .text                     ; Section containing code

global _start                     ; Linker needs this to find the entry point!

_start:
    mov rax, 1                    ; Code for sys_write call
    mov rdi, 1                    ; Specify File Descriptor 1: Standard Output
    mov rsi, EatMsg               ; Pass offset of the message
    mov rdx, EatLen               ; Pass the length of the message
    syscall                       ; Make kernel call

    mov rax, 60                   ; Code for exit syscall
    mov rdi, 0                    ; Return a code of zero
    syscall                       ; Make kernel call
