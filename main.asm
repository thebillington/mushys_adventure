INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "music/gbt_player.inc"
INCLUDE "images/images.inc"

; -------- INCLUDE UTILITIES --------
INClUDE "util.asm"
INCLUDE "constants.inc"

; -------- INCLUDE SPRITES --------
INCLUDE "sprites/tiles.asm"
INCLUDE "sprites/mushyBig.asm"
INCLUDE "sprites/mushyMid.asm"
INCLUDE "sprites/mushySmall.asm"

; -------- INCLUDE LEVELS --------
INCLUDE "levels/level.asm"

; -------- INCLUDE CREDITS --------
INCLUDE "images/asm/credits.asm"    ; Fix with ROM banking

; -------- INTERRUPT VECTORS --------
; specific memory addresses are called when a hardware interrupt triggers


; Vertical-blank triggers each time the screen finishes drawing. Video-RAM
; (VRAM) is only available during VBLANK. So this is when updating OAM /
; sprites is executed.
SECTION "VBlank", ROM0[$0040]
    jp VBHandler    ; Jump to VBlank handler routine

; LCDC interrupts are LCD-specific interrupts (not including vblank) such as
; interrupting when the gameboy draws a specific horizontal line on-screen
SECTION "LCDC", ROM0[$0048]
    reti

; Timer interrupt is triggered when the timer, rTIMA, ($FF05) overflows.
; rDIV, rTIMA, rTMA, rTAC all control the timer.
SECTION "Timer", ROM0[$0050]
    jp TIHandler    ; Jump to timer handler routine

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
    ld SP, $FFFF    ; Set stack pointer to the top of HRAM

    ClearRAM        ; ClearRAM MACRO

    DMA_COPY        ; Copy the DMA Routine to HRAM

;  -------- GBT_Player setup --------
    ld de, song_data
    ld bc, BANK(song_data)
    ld a, $05
    call gbt_play
    call gbt_loop

;  -------- Timer setup --------
    xor a               ; (ld a, 0)
    ld [rTIMA], a       ; Set TIMA to 0
    or TACF_STOP        ; Set STOP bit in A
    or TACF_4KHZ        ; Set divider bit in A
    ld [rTAC], a        ; Load TAC with A (settings)
    ld a, TMA_Value     ; Load A with modulo value
    ld [rTMA], a        ; Load TMA with A
    ld [rTIMA], a       ; Load TIMA with A (Reset to zero)

;  -------- Enable interrupts --------
    xor a           ; (ld a, 0)
    or IEF_VBLANK   ; Load VBlank mask into A
    or IEF_TIMER    ; Load Timer mask into A
    ld [rIE], a     ; Set interrupt flags
    ei              ; Enable interrupts

;  -------- Timer start --------
    xor a           ; (ld a, 0)
    or TACF_4KHZ    ; Set divider bit in A 
    or TACF_START   ; Set START bit in A
    ld [rDIV], a    ; Load DIV with A (Reset to zero)
    ld [rTAC], a    ; Load TAC with A

; ------- Load colour pallet ----------
    ld a, %11100100     ; Load A with colour pallet settings
    ld [rBGP], a        ; Load BG colour pallet with A
    ld [rOBP0], a       ; Load OBJ0 colour pallet with A

; -------- Initial Configuration --------

.init
; -------- Clear the screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro
    ClearVRAM           ; utils_clear -> ClearVRAM Macro

; ------- Set scroll x and y ----------
    xor a               ; (ld a, 0)
    ld [rSCX], a        ; Load BG scroll Y with A
    ld [rSCY], a        ; Load BG scroll X with A

; -------- Splash screen and story --------

; -------- Load splash screen ---------
    LoadImageBanked mushysplash_tile_data, mushysplash_tile_data_end, mushysplash_map_data, mushysplash_map_data_end    ; utils_load -> LoadImageBanked Macro

    SwitchScreenOn LCD_SETTING  ; utils_hardware -> SwitchScreenOn Macro

.splash
    ; Comment/uncomment this to jump straight to game or display the splash screen and tutorial
    ;jp .startGame

; -------- Wait for start button press ------
    FetchJoypadState    ; utils_hardware -> FetchJoypadState MACRO
    and PADF_START      ; If start then set NZ flag

    jr z, .splash       ; If not start then loop

; -------- Load story 1 ---------
    LoadImageBankedSwitched mushystory1_tile_data, mushystory1_tile_data_end, mushystory1_map_data, mushystory1_map_data_end    ; utils_load -> LoadImageBankedSwitched Macro

.story1
; -------- Wait for A button press ------
    FetchJoypadState            ; utils_hardware -> FetchJoypadState MACRO
    and PADF_A                  ; If A then set NZ flag

    jr z, .story1               ; If not A then loop

; -------- Load story 2 ---------
    LoadImageBankedSwitched mushystory2_tile_data, mushystory2_tile_data_end, mushystory2_map_data, mushystory2_map_data_end    ; utils_load -> LoadImageBankedSwitched Macro

.story2
; -------- Checks whether button is still being pressed ------
    JpIfButtonHeld PADF_A, .story2     ; utils_hardware -> JpIfButtonHeld MACRO

; -------- Wait for A button press ------
    FetchJoypadState            ; utils_hardware -> FetchJoypadState MACRO
    and PADF_A                  ; If A then set NZ flag

    jr z, .story2               ; If not A then loop

; -------- Load story 3 ---------
    LoadImageBankedSwitched mushystory3_tile_data, mushystory3_tile_data_end, mushystory3_map_data, mushystory3_map_data_end    ; utils_load -> LoadImageBankedSwitched Macro

.story3
; -------- Checks whether button is still being pressed ------
    JpIfButtonHeld PADF_A, .story3     ; utils_hardware -> JpIfButtonHeld MACRO

; -------- Wait for A button press ------
    FetchJoypadState            ; utils_hardware -> FetchJoypadState MACRO
    and PADF_A                  ; If A then set NZ flag

    jr z, .story3               ; If not A then loop

; -------- Start of game code ---------
.startGame

; -------- Wipe all data from VRAM ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff MACRO

    ClearVRAM           ; utils_clear -> ClearScreen MACRO

; -------- Load tiles into VRAM ------
    CopyData _VRAM, TILES, TILESEND         ; utils_load -> CopyData MACRO
    CopyData _BLOCK1, MUSHYBIG, MUSHYBIGEND ; utils_load -> CopyData MACRO

; -------- Load level ---------
    LoadFloor   ; utils_load -> LoadFloor MACRO
    LoadLevel   ; utils_load -> LoadLevel MACRO

; ------- Init player sprite into OAM -------
    LoadPlayer  ; utils_load -> LoadPlayer MACRO

; ------- Init player sprite into OAM -------
    InitialisePhysics   ; utils_physics -> InitialisePhysics MACRO

; -------- Set screen enable settings ---------
    SwitchScreenOn LCD_SETTING  ; utils_hardware -> SwitchScreenOn MACRO

; -------- START Main Loop ---------
.loop
    WaitVBlankIF                        ; Wait for VBlank interrupt (this should get us running at ~60Hz)

    UpdatePhysics                       ; utils_physics -> UpdatePhysics MACRO

    CheckEndLevel .loadCredits          ; utils_level -> CheckEndLevel MACRO

    jp .loop                            ; Jump back to the top of the game loop

; -------- END Main Loop --------

.loadCredits

    xor a
    ld[rSCX], a                         ; Reset screen scroll position

; -------- Load credits ---------
    LoadImageSwitched credits_tile_data, credits_tile_data_end, credits_map_data, credits_map_data_end  ; utils_load -> LoadImageSwitched Macro

.credits
; -------- Checks whether button is still being pressed ------
    JpIfButtonHeld PADF_A, .credits     ; utils_hardware -> FetchJoypadState MACRO

; -------- Wait for A button press ------
    FetchJoypadState            ; utils_hardware -> FetchJoypadState MACRO
    and PADF_A                  ; If A then set NZ flag

    jr z, .credits               ; If not A then loop

; -------- After credits, restart game ------
jp .init

; -------- Lock up the CPU ---------
.debug         
    jr .debug      ; Use to lock CPU for debugging

; -------- VBlank Interrupt Handler ---------
VBHandler:
    push hl                 ; Preserve HL register

    ld hl, INTR_STATE       ; Load INTR_STATE loc to hl
    ld [hl], IEF_VBLANK     ; load IEF_VBLANK to INTR_STATE

    pop hl                  ; Restore HL register

    jp _HRAM                ; Jump to the start of DMA Routine

; -------- Timer Interrupt Handler ---------
TIHandler:
    push hl         ; Preserve HL register
    push de         ; Preserve DE register
    push bc         ; Preserve BC register
    push af         ; Preserve AF register

    call gbt_update ; Update sound player

    pop af          ; Restore AF register
    pop bc          ; Restore BC register
    pop de          ; Restore DE register
    pop hl          ; Restore HL register
    
    reti            ; Return and enable interrupts