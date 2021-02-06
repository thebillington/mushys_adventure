INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

; -------- Sprite Macros --------
; Generic sprite function
_Spr_get: MACRO
.getLoop\@
    and $FF             ; AND A with $FF
    jr z, .getEnd\@     ; If result 0, return value
    ld bc, 4            ; load sprite offset into BC
    add hl, bc          ; Point HL to next Y
    dec a               ; Decrement A (count)
    jr .getLoop\@       ; Continue loop
.getEnd\@
ENDM

; Loads HL with specified sprite Y memory location
Spr_getY: MACRO
    ld hl, OAMDATALOC   ; Load HL with pointer to RAM sprite sheet
    ld a, \1            ; Load A with sprite parameter

    _Spr_get
ENDM

; Loads HL with specified sprite X memory location
Spr_getX: MACRO
    ld hl, (OAMDATALOC + 1) ; Load HL with pointer to (RAM sprite sheet + X offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get
ENDM

; Loads HL with specified sprite Tile memory location
Spr_getTile: MACRO
    ld hl, (OAMDATALOC + 2) ; Load HL with pointer to (RAM sprite sheet + Tile offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get
ENDM

; Loads HL with specified sprite Attribute memory location
Spr_getAttr: MACRO
    ld hl, (OAMDATALOC + 3) ; Load HL with pointer to (RAM sprite sheet + Attribute offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get
ENDM