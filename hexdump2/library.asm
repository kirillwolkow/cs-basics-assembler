; Name:         library - as this example is to show how to create one
; Last update:  2022-11-02
; Author:       Lukas Ith
; Description:  A library example implementing two simple procedures


section .data
    ; Lookup table for hexadecimal digits
    Digits:         db "0123456789ABCDEF"

section .text

global get_hex, get_ascii           ; procedures that can be imported by linked code

; -----------------------------------------------------------------------------
; Procedure:    gets the hexadecimal representation of a byte
; Input:        byte in al
; Returns:      hex character for high nibble in al, hex character for low nibble in ah (little endian)

get_hex:
    push rbx                        ; save rbx
    xor rbx, rbx                    ; clear rbx

    mov bl, al                      ; copy byte for processing into bl

    ; Look up character for low nibble and insert it into ah
    and ax, 0x000f                  ; mask low nibble; ensure upper bits to be set to 0
    mov ah, [Digits + rax]          ; look up character for low nibble and copy it to low byte

    ; Look up character for high nibble and insert it into al
    shr bl, 4                       ; shift high nibble to least significant bits
    mov al, [Digits + rbx]          ; look up character for high nibble and copy it to high byte

    pop rbx;                        ; restore rbx

    ret                             ; return with result in ax


    ; shr al, 4                       ; shift high nibble to least significant bits
    ; mov al, [Digits + rax]          ; look up character for low nibble and copy it to low byte

    ; and bl, 0x0f
    ; mov ah, [Digits + rbx]


; -----------------------------------------------------------------------------
; Procedure:    gets the printable ascii character for a byte, '.' if character is nor printable
; Input:        byte in al
; Returns:      printable ascii character in al

get_ascii:
    cmp al, 0x20                    ; compare with lowest printable character
    jb .return_dot                  ; lower? return dot

    cmp al, 0x7e                    ; compare with highest printable character
    ja .return_dot                  ; higher? return dot

    ret                             ; otherwise: return as is (keep al)

.return_dot:
    mov byte al, "."                ; set dot to al
    ret                             ; and return