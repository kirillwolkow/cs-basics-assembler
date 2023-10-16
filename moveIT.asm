SECTION .data
	test: db "My first Memory Access",10
SECTION .bss
	InBufLen:       equ 16
	InBuf:          resb InBufLen    ; reserve uninitialized memory

SECTION .text

global _start
_start:
	mov rax, 42	 ; 42 in RAX speichern
	mov rbx, 'Hello' ; String Hello in RBX Ablegen
	mov rcx, 0abcdh	 ; einen HEX Wert in RCX Ablegen
	mov dl, 67efh	 ; Overflow Wert in DL - cutoff
	mov dh, 67efh	 ; Overflow Wert in DH - cutoff

	call del	 ; Register Loeschen

	mov rax, [test]	 ; Erste 8 Zeichen des Strings in RAX (64 Bit = 8 Byte)
	mov rbx, test	 ; Adresse des ersten Zeichens in RAX ablegen
	mov cx, [rbx]    ; Erste 2 Zeichen des Speicher bei Adresse RBX in CX ablegen => 'My'
	mov edx, [rbx + 3] ; 4 Zeichen des Speichers ab Adresse RBX + 3 in EDX => 'firs'

	push rax;	 ; RAX Register auf den Stack legen
	call del	 ; Register Loeschen
	pop rax;	 ; RAX Register vom Stack holen

	mov eax, 0xFFFFFFFF	; Max Int auf EAX (32Bit) = 4294967295 od -1
	inc eax			; 2^32 + 1 = 0
	mov eax, 0x7FFFFFFF	; Max sig Int auf EAX (32 Bit)
	inc eax			; (2^31-1) + 1 = - 2^31 / oder 2^31 (unsig)
	mov rax, 0xFFFFFFFFFFFFFFFF ; Max Int auf RAX = 2^64
	inc rax			; um eins erhoehen = 0 gleich wie bei EAX 

	call del	 ; Register loeschen	

	mov rax, 42	 ; 42 ins RAX
	neg rax		 ; 2-Komplement bilden
	add rax, 42	 ; RAX = RAX + 42 => 0

	call del	 ; Register loeschen

	mov ax, -42	 ; -42 ins AX = FFD6 (16 Bit)
	mov bx, ax	 ; Kopie ins BX = FFD6 (16 Bit)
	mov ecx, eax 	 ; Kopie ins ECX = 0000FFD6 = 65494 (32 Bit)
	movsx edx, ax	 ; Vorzeichenbehaftete Kopie ins EDX = FFFFFFD6 = -42

			; properly end program
	mov rax, 60 	; Code for sys_exit
	mov rdi, 0  	; Return a code of zero
	syscall     	; Make kernel call

del:	mov rax, [rsp]	; RAX mit dem Inhalt des akt. Stackpointers fuellen
	push rax	; RAX Inhalt auf den Stack legen
	xor rax, rax	; RAX loeschen
	xor rbx, rbx	; RBX loeschen
	xor rcx, rcx	; RCX loeschen
	xor rdx, rdx	; RDX loeschen
	pop rdi		; Vorheriger RAX Wert vom Stack ins RDI legen
	ret		; Rueckkehr aus der Loeschroutine
