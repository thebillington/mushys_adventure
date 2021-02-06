INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

; -------- Level Macros --------
CheckEndLevel: MACRO
    
    ; Load bc with the value of the first tile of the first column of data
    ld a, [LEVEL_COLUMN_POINTER_LOW]
    ld b, a
    ld a, [LEVEL_COLUMN_POINTER_HIGH]
    ld c, a

    ld hl, LEVELEND                                 ; Load the address holding the end of the level

    AddSixteenBitHL 13 * 8

    ld a, b
    sub h                                           ; Ld the current location of b in and sub h (Check the high bits against each other)

    jp c, .endCheck\@                               ; If the result isn't positive  leave the check as we aren't at the end

    ld a, c
    sub l                                           ; Ld the current location of c in and sub l (Check the high bits against each other)

    jp c, .endCheck\@                               ; If the result isn't positive  leave the check as we aren't at the end

    jr \1                                           ; If we have reached this point, we are at the end, so jump to the passed label

.endCheck\@

ENDM