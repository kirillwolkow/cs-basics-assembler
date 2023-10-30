; Executable name : printf
; Last update     : 2022-11-09
; Author          : Lukas Ith 
; Description     : A simple program which calls printf() from libc.
; 
; Build using
;   make
; Note: need to be compiles with gcc -no-pie
; The option -no-pie is telling gcc not to make a position independent executable (PIE) as it would be needed to use
; address space layout randomization (ASLR).
; Having PIE enabled (default) results in the warning: relocation in read-only section `.text'

SECTION .data
    Message: db "The answer is %d.",10 ,0   ; the 0-terminated format string for printf
                                ; Note: In a C program a newline can be written as \n.
                                ; It is replaces by the _compiler_ with a newline character (0x10).
                                ; Thus, if we write "...\n" in a C format string, a newline character
                                ; is passed to printf() and not the single characters '\' and 'n'.
                                ; In fact, printf does not interpret \n but just prints them verbatim.
                                ; If we want nasm to interpret a string the way the C compiler does,
                                ; must place it between backticks: `...\n` replaces \n by a newline.
;   Message: db `The answer is %d.\n`       ; Alternative to above format string.

SECTION .text

extern printf                   ; link to libc's int printf(const char* format, ...)
global main                     ; procedure to be called from standard library

main:
    ; setup stack frame
    push rbp                    ; save the previous stack frame pointer on the stack
    mov rbp, rsp                ; and set new one

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

    mov rdi, Message            ; format string
    mov rsi, 42                 ; first variable argument
    mov rax, 0                  ; number of variable vector registers used to pass arguments
                                ; Note: printf() accepts a variable number of arguments (so-called ellipsis).
                                ; Floating point values are not passed in general purpose registers (rdi, rsi, rdx, ...)
                                ; but in vector registers (xmm0, xmm1, ...). As we use no floating point argument,
                                ; the number of such arguments must be set to 0.
    call printf WRT ..plt       ; call printf
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