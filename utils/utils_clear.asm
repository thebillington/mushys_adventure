INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

; -------- Clearing Macros --------
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

    ld hl, _VRAM               ; Load HL with pointer to the BG tile data
    ld de, _BG_MAP              ; Load DE with pointer to the BG tile map
    ld bc, _VRAM_END - _VRAM   ; Load BC with length of BG tile data + BG tile map banks

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