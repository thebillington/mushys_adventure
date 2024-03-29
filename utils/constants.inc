INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

    IF !DEF(CONSTANTS_INC)
DEF CONSTANTS_INC = 1

; -------- Constants --------
_RAM_END EQU $DFFF                      ; $C000->$DFFF
_VRAM_END EQU $9FFF                     ; $8000->$9FFF
_BG_MAP EQU $9000                       ; $9000->$97FF

OAMDATALOC EQU _RAM                     ; Using the first 160 bytes of RAM as OAM
OAMDATALOCBANK EQU OAMDATALOC / $100    ; gets the upper byte of location

TMA_Value EQU $99                       ; Timer modulo value

PLAYER_START_POS_Y EQU $70              ; Starting player y location
PLAYER_START_POS_X EQU $10              ; Starting player x location

FIRST_COL_TO_LOAD EQU 28                ; Starting column for conveyor loading
LEVEL_BEGIN EQU $9840                   ; First tile for level tilemap
FLOOR_BEGIN EQU $99E0                   ; First tile for floor tilemap

JUMP_POWER EQU 3                        ; Jump power constant
TERMINAL_VEL EQU 2                      ; Max speed constant

GRAVITY EQU -1                          ; Gravitational constant
GRAVITY_DELAY EQU 16                    ; Only apply gravity once every X frames, where X is the GRAVITY_DELAY

TOP_OF_FLOOR EQU 16 * 8                 ; $80 (128 denary) which is the top of the floor (the floor is 16 tiles from the top, 16 * 8 = 128)
RIGHT_BOUND EQU 9 * 8                   ; $30 (78 denary) which is the right bound (the bound is 9 tiles from the left, 9 * 8 = 78)

    ENDC ; CONSTANTS_INC