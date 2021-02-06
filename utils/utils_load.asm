INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Loading Macros --------
; Copys data from src address to dst address
CopyData: MACRO

    ld hl, \1               ; Load HL with pointer to dst address
    ld de, \2               ; Load DE with pointer to the start of src data
    ld bc, \3 - \2          ; Load BC with pointer to the end of src data

.copyDataLoop\@
    ld a, [de]              ; Load src data into A
    ld [hli], a             ; Load A into dst address and move to next address
    inc de                  ; Move to next src data address
    dec bc                  ; Decrement length of src data (count)
    ld a, b                 ; Load A with 8 LSBs of count
    or c                    ; OR count 8 LSBs with its 8 MSBs
    jr nz, .copyDataLoop\@  ; If the result is not zero (BC ~= 0), continue loop
ENDM

; Load image data and map to VRAM
LoadImage: MACRO
; -------- Load image data ------
    CopyData _VRAM, \1, \2

; -------- Load image map ------
    CopyData _SCRN0, \3, \4
ENDM

; Load image data and map to VRAM, switch screen
LoadImageSwitched: MACRO
    SwitchScreenOff

    LoadImage \1, \2, \3, \4    ; LoadImage MACRO

    SwitchScreenOn \5
ENDM

; Load an image file from bank
LoadImageBanked: MACRO

    ld a, BANK(\1)              ; Load bank containing the label to a
    ld [rROMB0], a              ; Load bank to bank register to switch

    LoadImage \1, \2, \3, \4    ; LoadImage MACRO

ENDM

; Load an image file from bank, switch screen
LoadImageBankedSwitched: MACRO
    SwitchScreenOff

    LoadImageBanked \1, \2, \3, \4  ; LoadImageBanked MACRO

    SwitchScreenOn \5

ENDM

; Loads level data pointers into RAM and the first 28 columns of level data
LoadLevel: MACRO

    ; Load bc with the value of the first tile of the first column of data
    ld bc, LEVEL

    ld hl, COLUMN_LOAD_COUNTER          
    ld [hl], FIRST_COL_TO_LOAD

    ld hl, COLUMN_OFFSET_X
    ld [hl], $0

.levelInitLoop\@
    ld de, LEVEL_BEGIN

    ld a, [COLUMN_OFFSET_X]
    add e
    ld e, a

    LoadLevelColumn

    ld a, [COLUMN_OFFSET_X]
    inc a
    ld hl, COLUMN_OFFSET_X
    ld [hl], a

    ld a, [COLUMN_LOAD_COUNTER]
    dec a
    ld hl, COLUMN_LOAD_COUNTER
    ld [hl], a

    jr nz, .levelInitLoop\@

ENDM

LoadLevelColumn: MACRO
    
    ; Before calling BC needs to hold the memory location holding the value of the next tile (LEVEL_COLUMN_POINTER_HIGH + LEVEL_COLUMN_POINTER_LOW)
    ; Before calling DE needs to hold the memory location of the tile in the top row of the next column to draw

    ld hl, ROW_LOAD_COUNTER          
    ld [hl], $0D

.loadColumnLoop\@
    ld a, [bc]

    ld h, d
    ld l, e
    ld [hl], a

    inc bc
    AddSixteenBitDE $20

    ld a, [ROW_LOAD_COUNTER]
    dec a
    ld hl, ROW_LOAD_COUNTER
    ld [hl], a

    jr nz, .loadColumnLoop\@     ; If we haven't finished loading the level jump up to the next tile map location

    ; Store the location into RAM
    ld hl, LEVEL_COLUMN_POINTER_LOW
    ld [hl], b
    ld hl, LEVEL_COLUMN_POINTER_HIGH
    ld [hl], c

ENDM

; Loads level data pointers into RAM and fills all 32 columns with the correct sprite tile
LoadFloor: MACRO

    ld hl, COLUMN_LOAD_COUNTER          
    ld [hl], $20

    ld hl, COLUMN_OFFSET_X
    ld [hl], $0

.floorLoop\@
    ld de, FLOOR_BEGIN

    ld a, [COLUMN_OFFSET_X]
    add e
    ld e, a

    LoadFloorColumn

    ld a, [COLUMN_OFFSET_X]
    inc a
    ld hl, COLUMN_OFFSET_X
    ld [hl], a

    ld a, [COLUMN_LOAD_COUNTER]
    dec a
    ld hl, COLUMN_LOAD_COUNTER
    ld [hl], a

    jr nz, .floorLoop\@

ENDM

LoadFloorColumn: MACRO
    
    ; Before calling DE needs to hold the memory location of the tile in the top row of the floor for the next column to draw

    ld hl, ROW_LOAD_COUNTER          
    ld [hl], $03

.floorColumnLoop\@

    ld h, d
    ld l, e
    ld [hl], $02

    inc bc
    AddSixteenBitDE $20

    ld a, [ROW_LOAD_COUNTER]
    dec a
    ld hl, ROW_LOAD_COUNTER
    ld [hl], a

    jr nz, .floorColumnLoop\@     ; If we haven't finished loading the level jump up to the next tile map location
ENDM