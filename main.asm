INCLUDE "hardware.inc"
INCLUDE "gbt_player.inc"
INClUDE "util.asm"
INCLUDE "dma.asm"

EXPORT  song_data
; -------- INCLUDE BACKGROUND TILES --------
INCLUDE "tiles.asm"

; -------- INCLUDE LEVELS --------
INCLUDE "level.asm"

; -------- INCLUDE SPLASH SCREEN --------
INCLUDE "images/splash.asm"

; -------- INTERRUPT VECTORS --------
; specific memory addresses are called when a hardware interrupt triggers


; Vertical-blank triggers each time the screen finishes drawing. Video-RAM
; (VRAM) is only available during VBLANK. So this is when updating OAM /
; sprites is executed.
SECTION "VBlank", ROM0[$0040]
    jp _HRAM    ; Jump to the start of DMA Routine

; LCDC interrupts are LCD-specific interrupts (not including vblank) such as
; interrupting when the gameboy draws a specific horizontal line on-screen
SECTION "LCDC", ROM0[$0048]
    reti

; Timer interrupt is triggered when the timer, rTIMA, ($FF05) overflows.
; rDIV, rTIMA, rTMA, rTAC all control the timer.
SECTION "Timer", ROM0[$0050]
    reti

; Serial interrupt occurs after the gameboy transfers a byte through the
; gameboy link cable.
SECTION "Serial", ROM0[$0058]
    reti

; Joypad interrupt occurs after a button has been pressed. Usually we don't
; enable this, and instead poll the joypad state each vblank
SECTION "Joypad", ROM0[$0060]
    reti

; -------- HEADER --------

SECTION "Header", ROM0[$0100]

EntryPoint:
    di          ; Disable interrupts
    jp Start    ; Jump to code start

; RGBFIX will fix this later
rept $150 - $104
    db 0
endr

; -------- MAIN --------

SECTION "Game Code", ROM0[$0150]

Start:
    ld SP, $FFFF        ; Set stack pointer to the top of HRAM

    ClearRAM            ; ClearRAM MACRO

    DMA_COPY            ; Copy the DMA Routine to HRAM

    ld a, IEF_VBLANK    ; Load VBlank mask into A
    ld [rIE], a         ; Set VBlank interrupt flag
    ei                  ; Enable interrupts

    ; -------- WaitVBlank --------

    WaitVBlank

; -------- Initial Configuration --------

    ; -------- Init LCDC register ---------
    xor a ; (ld a, 0)
    ld [rLCDC], a

    ; -------- Clear the screen ---------
    ClearScreen

    ; -------- Load splash screen tile data ------
    CopyData _VRAM, mushysplash_tile_data, mushysplash_tile_data_end

    ; ------- Load colour pallet ----------
    ld a, %11100100
    ld [rBGP], a    ; BG pallet
    ld [rOBP0], a   ; OBJ0 pallet

    ; ------- Set scroll x and y ----------
    xor a ; (ld a, 0)
    ld [rSCX], a
    ld [rSCY], a

    ;  -------- GBT_Player Setup --------
    ld de, song_data
    ld bc, BANK(song_data)
    ld a, $05
    call gbt_play
    ;  -------- GBT_Player Setup END --------

    ; -------- Turn screen back on ---------
    xor a
    or LCDCF_ON
    or LCDCF_BGON
    or LCDCF_OBJ8
    or LCDCF_OBJON
    
    ; -------- Set screen enable settings ---------
    ; Bit 7 - LCD Display Enable
    ; Bit 6 - Window Tile Map Display Select
    ; Bit 5 - Window Display Enable
    ; Bit 4 - BG & Window Tile Data Select
    ; Bit 3 - BG Tile Map Display Select
    ; Bit 2 - OBJ (Sprite) Size
    ; Bit 1 - OBJ (Sprite) Display Enable
    ; Bit 0 - BG/Window Display/Priority
    ld a, %10010001
    ld [rLCDC], a

    ; -------- Load splash screen tile map ------
    CopyTileMap _SCRN0, mushysplash_map_data, mushysplash_map_data_end

.splash
    ; -------- Sound stuff ------
    halt
    call gbt_update

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

    and PADF_START  ; If start then set NZ flag

    jr z, .splash     ; If not start then loop

; -------- START GAME --------

    ; -------- Clear screen ------
    ClearScreen

    ; -------- Clear tiles ------
    ClearTileMap

    ; -------- Load images into VRAM ------
    CopyTileMap _VRAM, TILES, TILESEND

    ; -------- Set screen enable settings ---------
    LoadLevel LEVEL, LEVELEND

; -------- Top of game loop ---------
.loop
    ; -------- Sound stuff ------
    halt
    call gbt_update

    jp .loop             ; Jump to the top of the game loop

; -------- Lock up the CPU ---------
.debug         
    jr .debug          ; Should never be reached - use jp .lockup at any point for debugging