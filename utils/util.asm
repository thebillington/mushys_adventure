INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

; -------- Constants --------
_RAM_END EQU $DFFF
_VRAM_END EQU $9FF0
_BG_MAP EQU $9000

OAMDATALOC EQU _RAM                   ; Using the first 160 bytes of RAM as OAM
OAMDATALOCBANK EQU OAMDATALOC / $100  ; gets the upper byte of location

TMA_Value EQU $99

PLAYER_START_POS_Y EQU $70
PLAYER_START_POS_X EQU $10

FIRST_COL_TO_LOAD EQU 28

JUMP_POWER EQU 3
TERMINAL_VEL EQU 2

GRAVITY EQU -1
GRAVITY_DELAY EQU 16                    ; Only apply gravity once every X frames, where X is the GRAVITY_DELAY

TOP_OF_FLOOR EQU 16 * 8                 ; $80 (128 denary) which is the top of the floor (the floor is 16 tiles from the top, 16 * 8 = 128)
RIGHT_BOUND EQU 9 * 8                   ; $30 (78 denary) which is the right bound (the bound is 9 tiles from the left, 9 * 8 = 78)

; -------- Macros --------
INCLUDE "utils_clear.asm"

INCLUDE "utils_dma.asm"

INCLUDE "utils_hardware.asm"

INCLUDE "utils_load.asm"

INCLUDE "utils_math.asm"

INCLUDE "utils_physics.asm"

INCLUDE "utils_player.asm"

INCLUDE "utils_sprite.asm"

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