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
    WaitVBlank      ; WaitVBlank MACRO

; -------- Initial Configuration --------

; -------- Turn screen off ------
    xor a           ; (ld A, 0)
    ld [rLCDC], a   ; Load A into LCDC register

; -------- Clear the screen ---------
    ClearScreenFast     ; ClearScreenFast MACRO

; -------- Load splash screen tile data ------
    CopyDataFast _VRAM, mushysplash_tile_data, mushysplash_tile_data_end    ; CopyDataFast MACRO

; ------- Load colour pallet ----------
    ld a, %11100100     ; Load A with colour pallet settings
    ld [rBGP], a        ; Load BG colour pallet with A
    ld [rOBP0], a       ; Load OBJ0 colour pallet with A

; ------- Set scroll x and y ----------
    xor a               ; (ld a, 0)
    ld [rSCX], a        ; Load BG scroll Y with A
    ld [rSCY], a        ; Load BG scroll X with A

;  -------- GBT_Player Setup --------
    ld de, song_data
    ld bc, BANK(song_data)
    ld a, $05
    call gbt_play

; -------- Turn screen on ---------
    xor a               ; (ld a, 0)
    or LCDCF_ON         ; Set LCD enabled bit in A
    or LCDCF_BGON       ; Set BG enabled bit in A
    or LCDCF_BG8000     ; Set BG Tile Data Set bit in A
    ld [rLCDC], a       ; Load LCDC with A (settings)

; -------- Load splash screen tile map ------
    CopyDataSlow _SCRN0, mushysplash_map_data, mushysplash_map_data_end     ; CopyDataSlow MACRO

; -------- END Initial Configuration --------

; -------- Main Loop --------

.splash_screen
; -------- Sound stuff ------
    halt
    call gbt_update

; -------- Read hardware inputs ------
    ReadHWInput             ; ReadHWInput MACRO
    and PADF_START          ; If start then set NZ flag

    jr z, .splash_screen    ; If not start then loop

; -------- Game loop setup --------

; -------- Turn screen off ------
    xor a           ; (ld A, 0)
    ld [rLCDC], a   ; Load A into LCDC register

; -------- Clear screen ------
    ClearScreenFast     ; ClearScreenFast MACRO

; -------- Load images into VRAM ------
    CopyDataFast _VRAM, TILES, TILESEND     ; CopyDataFast MACRO

; -------- Set screen enable settings ---------
    LoadLevel LEVEL, LEVELEND   ; LoadLevel MACRO

; -------- Turn screen on ---------
    xor a               ; (ld a, 0)
    or LCDCF_ON         ; Set LCD enabled bit in A
    or LCDCF_BGON       ; Set BG enabled bit in A
    or LCDCF_BG8000     ; Set BG Tile Data Set bit in A
    ld [rLCDC], a       ; Load LCDC with A (settings)

; -------- Top of game loop ---------
.loop
    ; -------- Sound stuff ------
    halt
    call gbt_update

    jp .loop             ; Jump to the top of the game loop

; -------- END Main Loop --------

; -------- Lock up the CPU ---------
.debug         
    jr .debug      ; Should never be reached