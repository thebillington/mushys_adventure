INCLUDE "hardware.inc"

_RAM_END EQU $DFFF
_VRAM_END EQU $9FF0
_BG_MAP EQU $9000

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

; Loads HL with specified sprite Y memory location & preserves registers
Spr_getY_P: MACRO
    push af             ; Preserve AF register
    push bc             ; Preserve BC register

    ld hl, OAMDATALOC   ; Load HL with pointer to RAM sprite sheet
    ld a, \1            ; Load A with sprite parameter

    _Spr_get

    pop bc              ; Restore BC register
    pop af              ; Restore AF register
ENDM

; Loads HL with specified sprite X memory location & preserves registers
Spr_getX_P: MACRO
    push af                 ; Preserve AF register
    push bc                 ; Preserve BC register

    ld hl, (OAMDATALOC + 1) ; Load HL with pointer to (RAM sprite sheet + X offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get

    pop bc                  ; Restore BC register
    pop af                  ; Restore AF register
ENDM

; Loads HL with specified sprite Tile memory location & preserves registers
Spr_getTile_P: MACRO
    push af                 ; Preserve AF register
    push bc                 ; Preserve BC register

    ld hl, (OAMDATALOC + 2) ; Load HL with pointer to (RAM sprite sheet + Tile offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get

    pop bc                  ; Restore BC register
    pop af                  ; Restore AF register
ENDM

; Loads HL with specified sprite Attribute memory location & preserves registers
Spr_getAttr_P: MACRO
    push af                 ; Preserve AF register
    push bc                 ; Preserve BC register

    ld hl, (OAMDATALOC + 3) ; Load HL with pointer to (RAM sprite sheet + Attribute offset)
    ld a, \1                ; Load A with sprite parameter

    _Spr_get

    pop bc                  ; Restore BC register
    pop af                  ; Restore AF register
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

; Writes 0s to RAM & preserves registers
ClearRAM_P: MACRO
    push hl     ; Preserve HL register
    push bc     ; Preserve BC register

    ClearRAM    ; ClearRAM MACRO

    pop bc      ; Restore BC register
    pop hl      ; Restore HL register
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

; Writes 0s to tile maps
ClearTileMap: MACRO

    ld hl, _VRAM                ; Load HL with pointer to the tile data
    ld de, $00                  ; Load DE with 0 (all empty tiles)
    ld bc, _SCRN0 - _VRAM       ; Load BC with length of tile data

.clearTileMapLoop\@
    ld a, d                     ; Load A with 8 MSBs of _BG_MAP
    ld [hl], a                  ; Load BG tile data with A
    ld a, e                     ; Load A with 8 LSBs of _BG_MAP
    ld [hl], a                  ; Load BG tile data with A
    inc hl                      ; Load HL with next VRAM address
    dec bc                      ; Decrement length of banks (count)
    ld a, c                     ; Load A with 8 LSBs of count
    or b                        ; OR count 8 LSBs with its 8 MSBs
    jr nz, .clearTileMapLoop\@   ; If the result is not zero (BC ~= 0), continue loop
ENDM

; Writes 0s to BG tile data & map & preserves registers
ClearScreen_P: MACRO
    push hl     ; Preserve HL register
    push de     ; Preserve DE register
    push bc     ; Preserve BC register

    ClearScreen ; ClearScreen MACRO

    pop bc      ; Restore BC register
    pop de      ; Restore DE register
    pop hl      ; Restore HL register
ENDM

; Copys data from src address to dst address
CopyData: MACRO

    ld hl, \1               ; Load HL with pointer to dst address
    ld de, \2               ; Load DE with pointer to the start of src data
    ld bc, \3 - \2          ; Load BC with length of src data

.copyDataLoop\@
    ld a, [de]              ; Load src data into A
    ld [hli], a             ; Load A into dst address and move to next address
    inc de                  ; Move to next src data address
    dec bc                  ; Decrement length of src data (count)
    ld a, b                 ; Load A with 8 LSBs of count
    or c                    ; OR count 8 LSBs with its 8 MSBs
    jr nz, .copyDataLoop\@  ; If the result is not zero (BC ~= 0), continue loop
ENDM

; Copys data from src address to dst address & preserves registers
CopyData_P: MACRO
    push hl     ; Preserve HL register
    push de     ; Preserve DE register
    push bc     ; Preserve BC register

    CopyData    ; CopyData MACRO

    pop bc      ; Restore BC register
    pop de      ; Restore DE register
    pop hl      ; Restore HL register
ENDM

; Loads the tile data into the correct positions for a level
LoadLevel: MACRO

    ; Load the VRAM location for the tile to map into HL
    ld hl, \1       ; Load the start of the level data into HL
    ld a, [hli]
    ld d, a         ; Load the data held at HL into d then increment HL
    ld a, [hli]
    ld e, a         ; Load the data held at HL into e then increment HL

    ; Load BC with the length of the level data
    ld bc, \2 - \1

.loadLevelLoop\@

    ld a, [hl]      ; Load a with the tile number to put into VRAM
    push af         ; Push a before we reuse the register

    ld a, d
    ld h, a
    ld a, e
    ld l, a         ; Move DE (the VRAM location of the tile) into HL

    WaitVBlank      ; WAIT FOR VBLANK BEFORE WRITING TO VRAM (woops)
    pop af          ; Retrieve our tile number
    ld [hl], a      ; Move the tile number into the memory location pointed to by HL

    inc de          ; Move DE to point to the next tile location
    dec bc
    dec bc
    dec bc          ; Decrement BC 3 times (each tile has 3 bytes of data)
    ld a, c
    or b
    jr nz, .loadLevelLoop\@     ; If we haven't finished loading the level jump up to the next tile map location
ENDM

; Waits for VBLANK before commiting any memory to VRAM
WaitVBlank: MACRO

.waitVBlank\@
    ld a, [rLY]             ; Load LCDC Y-Coordinate into A
    cp a, SCRN_Y            ; rLY - SCRN_Y
    jr c, .waitVBlank\@     ; if rLY < SCRN_Y then jump to .waitVBlank
ENDM