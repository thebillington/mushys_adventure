INCLUDE "hardware.inc"

_RAM_END EQU $DFFF
_VRAM_END EQU $9FF0
_BG_MAP EQU $9000

; Timer modulo value
__TMA_Value__ EQU $99

CNT EQU $C100

OAMDATALOC = _RAM  

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

; Writes 0s to RAM
ClearRAM: MACRO

    ld hl, _RAM             ; Load HL with pointer to RAM
    ld bc, _RAM_END - _RAM  ; Load BC with length of RAM

.clearRAMLoop\@
    xor a                   ; (ld a, $00)
    ld [hl], a              ; Set RAM address to 0
    inc hl                  ; Load HL with next RAM address
    dec bc                  ; Decrement length of RAM (count)
    ld a, c                 ; Load A with 8 LSBs of count
    or b                    ; OR count 8 LSBs with its 8 MSBs 
    jr nz, .clearRAMLoop\@  ; If result is not zero (BC ~= 0), continue loop
ENDM

; Writes 0s to BG tile data & map
ClearScreen: MACRO

    ld hl, _SCRN0               ; Load HL with pointer to the BG tile data
    ld de, _BG_MAP              ; Load DE with pointer to the BG tile map
    ld bc, _VRAM_END - _SCRN0   ; Load BC with length of BG tile data + BG tile map banks

.clearScreenLoop\@
    ld a, d                     ; Load A with 8 MSBs of _BG_MAP
    ld [hl], a                  ; Load BG tile data with A
    ld a, e                     ; Load A with 8 LSBs of _BG_MAP
    ld [hl], a                  ; Load BG tile data with A
    inc hl                      ; Load HL with next VRAM address
    dec bc                      ; Decrement length of banks (count)
    ld a, c                     ; Load A with 8 LSBs of count
    or b                        ; OR count 8 LSBs with its 8 MSBs
    jr nz, .clearScreenLoop\@   ; If the result is not zero (BC ~= 0), continue loop
ENDM

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

; Loads level data pointers into RAM and the first 28 columns of level data
LoadLevel: MACRO

    ; Load bc with the value of the first tile of the first column of data
    ld bc, LEVEL

    ; Store the location into RAM
    ld hl, LEVEL_COLUMN_POINTER_LOW
    ld [hl], b
    ld hl, LEVEL_COLUMN_POINTER_HIGH
    ld [hl], c

    ld hl, COLUMN_LOAD_COUNTER          
    ld [hl], $1C

    ld hl, COLUMN_OFFSET_X
    ld [hl], $0

.levelInitLoop\@
    ld de, $9840

    ld a, [COLUMN_OFFSET_X]
    add e
    ld e, a

    LoadLevelColumn

    ld a, [COLUMN_OFFSET_X]
    inc a
    ld hl, COLUMN_OFFSET_X
    ld [hl], a

    ld a, [COLUMN_LOAD_COUNTER]
    sub a, $01
    ld hl, COLUMN_LOAD_COUNTER
    ld [hl], a

    jr nz, .levelInitLoop\@

ENDM

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

CalculateNextColumnToLoad: MACRO

    ld a, [rSCX]                ; Load the screen x position

    MOD a, $20                  ; Divide by 32 and get the remainder (what is the current leftmost visible tile)
    ADD a, $1C                  ; Add 28 to get the offset
    MOD a, $20                  ; Calculate the X offset for the next column to load (leftmost visible tile + 20 + 8)

    ld [SCREEN_OFFSET_X], a     ; Store the value for the point at which we need to load the next tile

ENDM

LoadLevelColumn: MACRO
    
    ; Before calling BC needs to hold the memory location holding the value of the next tile (LEVEL_COLUMN_POINTER_HIGH + lh hl, LEVEL_COLUMN_POINTER_LOW)
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
    sub a, $01
    ld hl, ROW_LOAD_COUNTER
    ld [hl], a

    jr nz, .loadColumnLoop\@     ; If we haven't finished loading the level jump up to the next tile map location
ENDM

; Modulus method
MOD: MACRO

    ld a, \1

.divLoop\@
    sub \2

    jr nc, .divLoop\@
    add \2

ENDM

; Waits for VBLANK before commiting any memory to VRAM
WaitVBlank: MACRO

.waitVBlank\@
    ld a, [rLY]             ; Load LCDC Y-Coordinate into A
    cp a, SCRN_Y            ; rLY - SCRN_Y
    jr c, .waitVBlank\@     ; if rLY < SCRN_Y then jump to .waitVBlank
ENDM

; Gets the joypad state
FetchJoypadState: MACRO

    ld a, $20       ; Mask to pull bit 4 low (read the D pad)           #TODO: Replace hard coded value with EQU
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    swap a          ; Move the lower 4 bits to the upper 4 bits
    ld b, a         ; Save the buttons states to b

    ld a, $10       ; Mask to pull bit 4 low (read the buttons pad)     #TODO: Replace hard coded value with EQU
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    or b            ; Combine with the button states

    ld [PREV_BTN_STATE], a   ; store current state in RAM - use EQU

ENDM

; Load an image file
LoadImage: MACRO

    SwitchScreenOff

; -------- Load splash screen tile data ------
    CopyData _VRAM, \1, \2

; -------- Load splash screen tile map ------
    CopyData _SCRN0, \3, \4
    
; -------- Set screen enable settings ---------
    SwitchScreenOn \5

ENDM

; Wipe VRAM
WipeVRAM: MACRO

    SwitchScreenOff

; -------- Clear screen ------
    ClearScreen
    
; -------- Set screen enable settings ---------
    SwitchScreenOn \1

ENDM

; Switch screen off
SwitchScreenOn: MACRO
    
; -------- Set screen enable settings ---------
; Bit 7 - LCD Display Enable
; Bit 6 - Window Tile Map Display Select
; Bit 5 - Window Display Enable
; Bit 4 - BG & Window Tile Data Select
; Bit 3 - BG Tile Map Display Select
; Bit 2 - OBJ (Sprite) Size
; Bit 1 - OBJ (Sprite) Display Enable
; Bit 0 - BG/Window Display/Priority
    ld a, \1
    ld [rLCDC], a

ENDM

; Switch screen off
SwitchScreenOff: MACRO

; -------- Switch screen off ---------
    xor a           ; (ld a, 0)
    ld [rLCDC], a   ; Load A into LCDC register

ENDM

; Check state of button press
JpIfButtonHeld: MACRO

; -------- Check button state ---------
    ld a, [PREV_BTN_STATE]      ; Load last state from RAM - use EQU
    AND \1                      ; apply button mask
    ld b, a                     ; Load current state into b

    push bc
    FetchJoypadState            ; Check for button press
    AND \1                      ; apply button mask

    pop bc

    xor b                       ; Compare stored state vs current state

    jp z, \2    ; if not 0 jump to passed label
ENDM
