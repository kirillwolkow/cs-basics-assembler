; Executable name : printf
; Last update     : 2022-11-09
; Author          : Lukas Ith 
; Description:    : A simple program which calls puts() from libc.
;
; Build using
;   make
; Note: need to be compiles with gcc -no-pie
; The option -no-pie is telling gcc not to make a position independent executable (PIE) as it would be needed to use
; address space layout randomization (ASLR).
; Having PIE enabled (default) results in the warning: relocation in read-only section `.text'

SECTION .data

    EatMsg: db "Eat at Joe's!",0    ; string and terminating 0-byte

SECTION .text

extern puts                         ; link to libc's int puts(const char *s)

global main                         ; procedure to be called from standard library

main:
    ; setup stack frame
    push rbp
    mov rbp, rsp

    ; preserve used registers
;    push rbx
;    push r12
;    push r13
;    push r14
;    push r15
                                ; Note: Some operating systems (e.g. OS X, both 32 and 64 bit) require that
                                ; the stack pointer is 16 byte aligned before an external function call.
                                ; The stack was 16 byte aligned before main was called. The call pushed
                                ; the return address on the stack (which is 8 bytes in a 64 bit OS).
                                ; By additionally pushing the 64 bit rbp on the stack, the stack pointer
                                ; is aligned again.
                                ; If this is not the case, the stack pointer needs to be aligned before
                                ; calling printf. This can be done by subtracting the difference (e.g. 8 bytes)
                                ; from the stack pointer: sub rsp, 8

    ; call puts() from libc
    mov rdi, EatMsg                 ; address of string to write
    call puts WRT ..plt             ; gcc: with reference to process linkage table
                                    ; Note: as gcc uses dynamic linking by default, call uses nasm's WRT ("with
                                    ; reference to") to call into the procedure linkage table (PLT). This is not
                                    ; necessary when linking statically (gcc option "-static").

    ; restore used registers
;    pop r15
;    pop r14
;    pop r13
;    pop r12
;    pop rbx

    ; destroy stack frame
    mov rsp, rbp
    pop rbp

    ; return to libc
    ret
