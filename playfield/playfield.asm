section .data

section .bss

section .text

global _start

_start:
	; place your experiments here...
	nop

	mov rax, 60
	mov rdi, 0
	syscall
