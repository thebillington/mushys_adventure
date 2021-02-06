INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

InitialisePhysics: MACRO

    ld hl, Y_VEL
    ld [hl], -1                     ; Set the initial y velocity

    ld hl, CAN_JUMP
    ld [hl], 0                      ; Set can jump to false

    ld hl, GRAVITY_TIMER
    ld [hl], 0                      ; Set gravity timer to zero

    ld hl, COLUMN_LOAD_OFFSET
    ld [hl], FIRST_COL_TO_LOAD      ; Load the location of the first column to load into memory when scrolling

ENDM

UpdatePhysics: MACRO

    FetchJoypadState                ; Get the joypad state and store it into PREV_BTN_STATE

    UpdatePlayerY                   ; Update the player y position every frame
    CheckFloorCollision             ; Check if the player has entered the floor
    CheckPlatformCollisions         ; Check if the player has entered a platform

    CheckGravity                    ; Apply gravity

    CheckForJump                    ; Check if the player is jumping

    CheckHorizontalMovement         ; Check if any of the horizontal D-Pad buttons are down
    HorizontalBoundsCheck           ; 

ENDM

UpdatePlayerY: MACRO

    ld a, [Y_VEL]
    MovePlayerY a                   ; Move the player y position by the value held in Y_VEL

ENDM

CheckFloorCollision: MACRO

.collisionCheckLoop\@

    Spr_getY $02                    ; Load the memory location of the bottom left sprite of the player into HL
    ld a, [hl]                      ; Load the y position of the bottom of the player into A
    ld b, a                         ; Store the value into b
    ld a, TOP_OF_FLOOR              ; Load $80 into a (128 denary) which is the top of the floor (the floor is 16 tiles from the top, 16 * 8 = 128)
    sub b                           ; Subtract the players position
    jr nc, .endCheck\@              ; If the value didn't go negative, we are either on or above the floor, end the check

    MovePlayerY 1                   ; Move the player up by 1
    EnableJump                      ; Once we've hit the floor, let the player jump again

    jr .collisionCheckLoop\@        ; Check again to see if we have resolved the collision

.endCheck\@

ENDM

EnableJump: MACRO
    ld hl, CAN_JUMP
    ld [hl], 1                      ; Set can jump to true
ENDM

DisableJump: MACRO
    ld hl, CAN_JUMP
    ld [hl], 0                      ; Set can jump to false
ENDM

CheckForJump: MACRO

    ld a, [PREV_BTN_STATE]
    and PADF_A                              ; Load the pad state and mask it with the A button press

    jr z, .endCheck\@                       ; If A isn't pressed, end the check

    ld a, [CAN_JUMP]
    and 1
    jr z, .endCheck\@                       ; If the player can't jump (is already in the air) then end the check

    Jump                                    ; If we've reached here, the player has just pressed A; jump

.endCheck\@

ENDM

Jump: MACRO

    ld hl, Y_VEL
    ld [hl], JUMP_POWER                     ; Set the y velocity to jump power

    DisableJump                             ; Once we've jumped, disable it till next time we hit the floor
    ResetGravityTimer                       ; Also reset the gravity timer for consistent jump height

ENDM

CheckGravity: MACRO

    ld a, [GRAVITY_TIMER]
    and $FF
    jr z, .applyGravity\@                   ; If the gravity timer has hit zero, jump to apply gravity

    ld a, [GRAVITY_TIMER]
    sub 1
    ld hl, GRAVITY_TIMER
    ld [hl], a                              ; Otherwise reduce the timer by 1 and end the check

    jr .endCheck\@

.applyGravity\@
    ApplyGravity                            ; If we've reached this point, it is time to apply gravity

    ResetGravityTimer                       ; Reset the timer

.endCheck\@

ENDM

ResetGravityTimer: MACRO
    ld hl, GRAVITY_TIMER
    ld [hl], GRAVITY_DELAY                  ; Set the gravity timer to the delay
ENDM

ApplyGravity: MACRO

    ld a, [Y_VEL]
    ld b, a                                 ; Load the current Y velocity into b

    ld a, TERMINAL_VEL                      ; Load A with the value of terminal velocity
    add b                                   ; Add the current velocity

    jr z, .endCheck\@                       ; If we are at terminal velocity, end the check
    jr c, .setTerminal\@                    ; If we are above terminal velocity, set Y_VEL to terminal velocity

; If we reached this point, we need to apply gravity
    ld a, [Y_VEL]
    add GRAVITY                             ; Load Y_VEL and apply gravity

    ld hl, Y_VEL
    ld [hl], a                              ; Store back to Y_VEL

.setTerminal\@

    ld hl, Y_VEL
    ld [hl], 0 - TERMINAL_VEL               ; Set the value of Y_VEL to negative terminal velocity (we move down with gravity)

.endCheck\@

ENDM

CheckHorizontalMovement: MACRO

.rightPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_RIGHT                          ; Load the pad state and apply right button mask

    jr z, .leftPadCheck\@                   ; If right button isn't pressed, check for left button press

    MovePlayerX 1                           ; Move the player one to the right

    jr .endCheck\@                          ; If the right pad was checked, don't check the left pad

.leftPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_LEFT                          ; Load the pad state and apply left button mask

    jr z, .endCheck\@                      ; If left button isn't pressed, end check state

    MovePlayerX -1                         ; Move the player 1 to the left

.endCheck\@

ENDM

HorizontalBoundsCheck: MACRO

    HorizontalBoundsLeftCheck
    HorizontalBoundsRightCheck

ENDM

HorizontalBoundsLeftCheck: MACRO

.resolveOutOfBounds\@

    Spr_getX $00
    ld a, [hl]
    sub $08

    jr nc, .endCheck\@

    MovePlayerX 1
    jr .resolveOutOfBounds\@

.endCheck\@

ENDM

HorizontalBoundsRightCheck: MACRO

.resolveOutOfBounds\@

    Spr_getX $00
    ld a, [hl]
    ld b, a
    ld a, RIGHT_BOUND
    sub b

    jp nc, .endCheck\@

    MovePlayerX -1

    CheckEndLevel .endCheck\@                       ; Check if we are already at the end of the level
    ScrollMapX                                      ; If not, scroll the map

    jp .resolveOutOfBounds\@

.endCheck\@  

ENDM

ScrollMapX: MACRO

    ld a, [rSCX]
    inc a
    ld hl, rSCX
    ld [hl], a

    CheckColumnLoad

ENDM

CheckColumnLoad: MACRO

    ld a, [rSCX]
    MOD a, $08
    AND $FF                                         ; Load in the current screen X and check if we have just entered a new tile
    
    jr nz, .endCheck\@                              ; If we aren't in a new tile, end the check

    LoadNextColumn

.endCheck\@

ENDM

LoadNextColumn: MACRO

    WaitVBlankIF
    
    ; Load bc with the value of the first tile of the first column of data
    ld a, [LEVEL_COLUMN_POINTER_LOW]
    ld b, a
    ld a, [LEVEL_COLUMN_POINTER_HIGH]
    ld c, a

    ld de, $9840                                    ; Load de with the top left tile of our map (the first 2 rows don't have any tiles in)

    ld a, [COLUMN_LOAD_OFFSET]
    MOD a, $20
    add e
    ld e, a                                         ; Offset by the required column offset (this loads into the correct column)

    LoadLevelColumn                                 ; Initiate the data load

    ld a, [COLUMN_LOAD_OFFSET]
    inc a
    ld hl, COLUMN_LOAD_OFFSET
    ld [hl], a

ENDM

CheckPlatformCollisions: MACRO

    CheckPlaformCollisionForSprite $02
    CheckPlaformCollisionForSprite $03

ENDM

CheckPlaformCollisionForSprite: MACRO

.collisionCheckLoop\@

    CalculateTilePosition \1                        ; Load the memory location of the tile we are currently standing on

    ld h, b
    ld l, c                                         ; Move BC into hl

    ld a, [hl]                                      ; Load the tile position data into a
    sub $01                                         ; Subtract the tile position that has collision enabled (platforms are tile position $01)

    jr nz, .endCheck\@                              ; If there is no collision, end the check

    MovePlayerY 1                                   ; Move the player up by 1
    EnableJump                                      ; Once we've hit the floor, let the player jump again

    jp .collisionCheckLoop\@                        ; Check again to see if we have resolved the collision

.endCheck\@

ENDM

CalculateTilePosition: MACRO

    Spr_getX \1
    ld a, [hl]                                      ; Get the x position of the sprite bottom left tile
    sub 8                                           ; Subtract 8 to account for the x offscreen tile position
    DIVIDE a, 8                                     ; Divide by 8 to normalise to a tile position
    ld d, a                                         ; Store in d

    ld a, [COLUMN_LOAD_OFFSET]                      ; Load a with the total column offset (this tracks how far we have moved)
    sub 29                                          ; Subtract 28 (normalise back to the start of the offset, instead of position 28 where we load new tiles)
    add d                                           ; Add our x tile position to the total offset position
    ld d, a

    ld bc, LEVEL                                   ; Load BC with the start of the level data
    
    AND 1
    jr z, .skipLoop\@

; Add 13 to BC d times to give us the total rows offset (each row contains 13 pieces of tile data)
    ld hl, GENERIC_ITERATOR
    ld [hl], 0

.addMultiple\@

    AddSixteenBitBC 13                              ; Add our total tile offset to the level data

    ld a, [GENERIC_ITERATOR]
    inc a
    ld hl, GENERIC_ITERATOR
    ld [hl], a                                      ; Increment the multiplier iterator

    sub d                                           ; Check if we have added A times

    jr nz, .addMultiple\@                           ; Add d, subtract 1 from

.skipLoop\@

; Calculate the y offset within the column

    ld d, b
    ld e, c
    Spr_getY \1
    ld b, d
    ld c, e

    ld a, [hl]                                      ; Get the y position of the sprite bottom left tile
    dec a
    ld d, a                                         ; Store it in d

    ld e, b

    add 24                                          ; Subtract 16 to account for the y offscreen tile positions
    DIVIDE a, 8                                     ; Divide by 8 to normalise to a tile position
    sub 8                                           ; Subtract 8 because it works (not sure why but trust)

    ld b, e
    inc a
    ld d, a
    AddSixteenBitBC d                               ; Add the y position offset to the current column position

ENDM