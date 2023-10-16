; Executable name:  File kangaroo.asm
; Author:           Emmanuel Benoist, Pascal Mainini
; Modified by:      Lukas Ith
; Date:             2021-10-28
; Compile with:     make

; example program converting the upper case letters in Snippet
; to lower case letters byadding 32 to the ASCII value
; --> watch code in the debugger
SECTION .data               ; Section containing initialized data
	Snippet: db "KANGAROO"  ; string to process

SECTION .text               ; Section containing code
	global _start           ; Linker needs this to find the entry point!

_start:
	mov rbx, Snippet        ; move Snippet's starting address to rbx
	mov rax, 8              ; initialize counter in rax to 8, the number of characters
loop:
	add byte [rbx], 32      ; add 32 to current letter in Snippet and turn upper to lower case
	inc rbx                 ; increment the address -> point to next byte
	dec rax                 ; decrement counter
	jnz loop                ; of it hasn't reached 0, process nect character
exit:
	mov rax, 60             ; Code for exit syscall
	mov rdi, 0              ; Return a code of zero
	syscall                 ; Make kernel call
