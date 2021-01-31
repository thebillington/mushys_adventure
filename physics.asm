INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

InitialisePhysics: MACRO

    ld hl, Y_VEL
    ld [hl], -1                     ; Set the initial y velocity

ENDM

UpdatePhysics: MACRO

    UpdatePlayerY                   ; Update the player y position every frame
    CheckFloorCollision             ; Check if the player has entered the floor

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

    MovePlayerY 1                  ; Move the player up by 1
    jr .collisionCheckLoop\@        ; Check again to see if we have resolved the collision

.endCheck\@

ENDM