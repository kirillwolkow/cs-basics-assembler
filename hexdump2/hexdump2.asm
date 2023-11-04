; Executable name:  hexdump2
; Last update:      2022-11-02
; Author:           Lukas Ith (based on work by Jeff Duntemann, Pascal Mainini and Andreas Hoffmann)
; Description:      A simple program in assembly, demonstrating the conversion
;                   of binary values to hexadecimal strings.
;
; Build using these commands:
;   make
; Run it this way:
;   ./hexdump2    # type input characters, end by Ctrl-d
; or
;   ./hexdump2 < (input file)
;
; Some explanations:
; - This program processes the input in chunks of 16 bytes (InBufLen).
; - The current chunk is stored in InBuf.
; - For every chunk an output line is built up in HexStr.
; - The finished line is printed with sys_write and the process starts over.
;
; - For every byte the hexadecimal digits are calculated in the external
;   procedure get_hex.
; - The digits are written in HexStr. Note that the spaces between the
;   hex digits are already in HexStr and don't need to be written in code.
;   The same applies for the end of line character (0x10).
;
; - Additionally the ascii representation is written at the end of line
; - The printable representation of the byte to display is looked up
;   with the external procedure get_ascii
;
; - The HexStr is re-used for every chunk/line and the digits from the last
;   line are overwritten with the values of the next line.
; - As the last line might not use all position we must clear the remaining
;   values. This is implemented in blank.
;
; Important registers:
; rax   work register
; rbx   temporary copy of values
; r10   number of bytes read from input
; r11   current position in InBuf


section .bss
    ; Reserve a buffer for reading from stdin
    InBufLen:       equ 16
    InBuf:          resb InBufLen    ; reserve uninitialized memory

section .data
    ; Reserve a buffer for compiling an output line
    HexStr:         db "xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx  "
            ; set spaces and newline already; so we don't need to place them in code
            ; note that xx will be replaced by hex values and never written out
            ; these are here just for documentation purposes.
    AsciiStr:       db "................", 10
            ; space for ascii representation; dots are for documentation propose only
            ; and will be overwritten.
    HexStrLen:      equ $ - HexStr  ; length of combined string


section .text

extern get_hex, get_ascii

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
    xor r11, r11                     ; set current buffer position to 0

process:
    ; prepare processing of next byte
    mov al, [InBuf + r11]           ; read next character of InBuf into al
    mov bl, al                      ; copy character for ascii output

    ; write hex value
    call get_hex                    ; get hex characters of byte in al in ax 
    mov [r11 + r11*2 + HexStr], ax  ; write two characters (in ah and al) to HexStr + r11 * 3

    ; write ascii character
    mov al, bl                      ; copy original byte value
    call get_ascii                  ; get printable ascii character
    mov [AsciiStr + r11], al        ; write ascii character to output

    ; check if we're finished with this line
    inc r11                         ; increment current byte position
    cmp r11, r10                    ; compare current position (r11) with # bytes to process (r10)
    jnae process                    ; loop if position < # bytes to process
                                    ; if not, this line is completed

blank:
    ; blank remaining values from previous line
    ; this is needed if last one did write all positions in the HexStr
    cmp r11, InBufLen               ; is the line complete?
    jnb writeline                   ; if so, skip filling
    mov word [r11 + r11*2 + HexStr], 0x2020 ; overwrite old values with two spaces
    mov byte [AsciiStr + r11], 0x20 ; overwrite old ascii character with space
    inc r11                         ; increment current position
    jmp blank                       ; try next position

writeline:
    ; write HexStr to stdout
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; file descriptor: stdout
    mov rsi, HexStr                 ; output buffer
    mov rdx, HexStrLen              ; # of bytes to write
    syscall

    ; Go back to read the next bytes from input
    jmp read

exit:
    mov rax, 60                     ; sys_exit
    mov rdi, 0                      ; success!
    syscall