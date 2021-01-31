INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

InitialisePhysics: MACRO

    ld hl, Y_VEL
    ld [hl], -1                     ; Set the initial y velocity

    ld hl, CAN_JUMP
    ld [hl], 0                      ; Set can jump to false

    ld hl, GRAVITY_TIMER
    ld [hl], 0                      ; Set gravity timer to zero

ENDM

UpdatePhysics: MACRO

    FetchJoypadState                ; Get the joypad state and store it into PREV_BTN_STATE

    UpdatePlayerY                   ; Update the player y position every frame
    CheckFloorCollision             ; Check if the player has entered the floor

    CheckGravity                    ; Apply gravity

    CheckForJump                    ; Check if the player is jumping

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
    ld a, Y_VEL
    add GRAVITY                             ; Load Y_VEL and apply gravity

    ld hl, Y_VEL
    ld [hl], a                              ; Store back to Y_VEL

.setTerminal\@

    ld hl, Y_VEL
    ld [hl], 0 - TERMINAL_VEL               ; Set the value of Y_VEL to negative terminal velocity (we move down with gravity)

.endCheck\@

ENDM