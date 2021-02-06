INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Maths Macros --------
AddSixteenBitBC: MACRO

    ld a, c
    add a, \1
    ld c, a
    ld a, b
    adc a, $00
    ld b, a

ENDM

AddSixteenBitDE: MACRO

    ld a, e
    add a, \1
    ld e, a
    ld a, d
    adc a, $00
    ld d, a

ENDM

AddSixteenBitHL: MACRO

    ld a, l
    add a, \1
    ld l, a
    ld a, h
    adc a, $00
    ld h, a

ENDM

; Modulus method
MOD: MACRO

    ld a, \1

.modLoop\@
    sub \2

    jr nc, .modLoop\@
    add \2

ENDM

; Divide method
DIVIDE: MACRO

    ld a, \1
    ld b, $00

.divLoop\@
    sub \2
    inc b

    jr nc, .divLoop\@
    ld a, b

ENDM

; Multiply method
MULT: MACRO

    ld c, a
    ld b, \1

.multLoop\@
    add c
    dec b

    jr nz, .multLoop\@

ENDM