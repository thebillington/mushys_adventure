INCLUDE "hardware.inc"
INCLUDE "gbt_player.inc"
INClUDE "util.asm"
INCLUDE "dma.asm"

EXPORT  song_data

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

.waitVBlank
    ld a, [rLY]         ; Load LCDC Y-Coordinate into A
    cp a, SCRN_Y        ; rLY - SCRN_Y
    jr c, .waitVBlank   ; if rLY < SCRN_Y then jump to .waitVBlank

; -------- Initial Configuration --------

    ; -------- Init LCDC register ---------
    xor a ; (ld a, 0)
    ld [rLCDC], a

    ; -------- Clear the screen ---------
    call ClearScreen

    ; ------- Load colour pallet ----------
    ld a, %11100100
    ld [rBGP], a    ; BG pallet
    ld [rOBP0], a   ; OBJ0 pallet

    ; ------- Set scroll x and y ----------
    xor a ; (ld a, 0)
    ld [rSCX], a
    ld [rSCY], a

    ; -------- Turn off sound --------------
    ld [rNR52], a

    ; -------- Turn screen back on ---------
    xor a
    or LCDCF_ON
    or LCDCF_BGON
    or LCDCF_OBJ8
    or LCDCF_OBJON
    ld [rLCDC], a

;  -------- GBT_Player Setup --------
    ld de, song_data
    ld bc, BANK(song_data)
    ld a, $05
    call gbt_play
;  -------- GBT_Player Setup END --------

; -------- Top of game loop ---------
.loop
    halt
    call gbt_update
    jp .loop             ; Jump to the top of the game loop

; -------- Lock up the CPU ---------
.lockup         
    jr .lockup          ; Should never be reached - use jp .lockup at any point for debugging