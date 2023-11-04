; Executable name : hexdump1
; Last update     : 2022-10-31
; Author          : Lukas Ith (based on work by Jeff Duntemann, Pascal Mainini and Andreas Hoffmann)
; Description     : A simple program in assembly, demonstrating the conversion
;                   of binary values to hexadecimal strings.
;
; Build using these commands:
;   make
; Run it this way:
;   ./hexdump1    # type input characters, end by Ctrl-d
; or
;   ./hexdump1 < (input file)
;
; Some explanations:
; - This program processes the input in chunks of 16 bytes (InBufLen).
; - The current chunk is stored in InBuf.
; - For every chunk an output line is built up in HexStr.
; - The finished line is printed with sys_write and the process starts over.
;
; - For every byte the hexadecimal digit for the high nibble and low nibble
;   are looked up in Digits.
; - The digits are written in HexStr. Note that the spaces between the
;   hex digits are already in HexStr and don't need to be written in code.
;   The same applies for the end of line character (0x10).
;
; - The HexStr is re-used for every chunk/line and the digits from the last
;   line are overwritten with the values of the next line.
; - As the last line might not use all position we must clear the remaining
;   values. This is implemented in blank.
;
; Important registers:
; rax   low nibble of current byte
; rbx   high nibble of current byte / hexadecimal characters both nibbles
; r10   number of bytes read from input
; r11   current position in InBuf


section .bss
    ; Reserve a buffer for reading from stdin
    InBufLen:       equ 16
    InBuf:          resb InBufLen    ; reserve uninitialized memory

section .data
    ; Reserve a buffer for compiling an output line
    HexStr:         db "xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx", 10
            ; set spaces and newline already; so we don't need to place them in code
            ; note that xx will be replaced by hex values and never written out
            ; these are here just for documentation purposes.
    HexStrLen:      equ $ - HexStr;

    ; Lookup table for hexadecimal digits
    Digits:         db "0123456789ABCDEF"

section .text

global _start

_start:

read:
    ; read chunk from stdin to InBuf
    mov rax, 0                      ; sys_read
    mov rdi, 0                      ; file descriptor: stdin
    mov rsi, InBuf                  ; destination buffer
    mov rdx, InBufLen               ; maximum # of bytes to read
    syscall

    ; check number of bytes read
    cmp rax, 0                      ; did we receive any bytes?
    je exit                         ; if not: exit the program

    ; Prepare registers for loop
    mov r10, rax                    ; save # of bytes read
    xor r11, r11                    ; set current buffer position to 0

process:
    ; Get next character
    mov al, [InBuf + r11]           ; read next character of InBuf into al
    mov bx, ax                      ; keep a copy of the byte as we need it later
                                    ; note that by copying bx (instead of just bl) we also clear the rest of the reg.

    ; Process high nibble (first hexadecimal digit)
    shr bl, 4                       ; shift high nibble to least significant bits
    mov bl, [Digits + rbx]          ; look up character for nibble and store it to bl

    ; Process low nibble (second hexadecimal digit)
    and al, 0x0f                    ; mask low nibble
    mov bh, [Digits + rax]          ; look up character for nibble and store it to bh 

    ; Write two hexadecimal digits to the correct position of HexStr
    mov [r11 + r11*2 + HexStr], bx  ; write two characters (in bh and bl) to HexStr + r11 * 3

    ; Check if we're finished with this line
    inc r11                         ; increment current byte position
    cmp r11, r10                    ; compare current position (r11) with # bytes to process (r10)
    jnae process                    ; loop if position < # bytes to process
                                    ; if not, this line is completed

blank:
    ; Blank remaining values from previous line
    ; This is needed if last one did not overwrite all positions in the HexStr
    cmp r11, InBufLen               ; is the line complete?
    jnb writeline                   ; if so, skip filling

    ; Overwrite two characters
    mov word [r11 + r11*2 + HexStr], 0x2020 ; overwrite old value with two spaces

    ; Finish loop
    inc r11                         ; increment current position
    jmp blank                       ; try next position

writeline:
    ; Write HexStr to stdout
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; file descriptor: stdout
    mov rsi, HexStr                 ; output buffer
    mov rdx, HexStrLen              ; # of bytes to write
    syscall

    ; Go back to read the next bytes from input
    jmp read

exit:
    ; Properly terminate program
    mov rax, 60                     ; sys_exit
    mov rdi, 0                      ; success!
    syscall