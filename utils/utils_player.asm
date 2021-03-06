INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

LoadPlayer: MACRO

    ld d, $00

.loadPlayerSpritesLoop\@

    Spr_getY d
    ld e, PLAYER_START_POS_Y
    ld a, d
    DIVIDE a, $02
    MULT $07
    add e
	ld [hl], a
    
    Spr_getX d
    ld e, PLAYER_START_POS_X
    ld a, d
    MOD a, $02
    MULT $07
    add e
	ld [hl], a        

    Spr_getTile d
    ld a, $80
    add d
    ld [hl], a

    Spr_getAttr d
    ld [hl], OAMF_PAL0

    ld a, $03
    sub d

    jr z, .loadPlayerFallthrough\@

    inc d
    jr .loadPlayerSpritesLoop\@

.loadPlayerFallthrough\@

ENDM

MovePlayerY: MACRO

    ld d, $00
    ld e, \1

.movePlayerYLoop\@

    Spr_getY d
    ld a, [hl]
    sub e                               ; Subtract the value so that we can treat positive numbers as up and negative as down
	ld [hl], a

    ld a, $03
    sub d

    jr z, .movePlayerYFallthrough\@

    inc d
    jr .movePlayerYLoop\@

.movePlayerYFallthrough\@

ENDM

MovePlayerX: MACRO

    ld d, $00
    ld e, \1

.movePlayerXLoop\@

    Spr_getX d
    ld a, [hl]
    add e                               ; Subtract the value so that we can treat positive numbers as up and negative as down
	ld [hl], a

    ld a, $03
    sub d

    jr z, .movePlayerXFallthrough\@

    inc d
    jr .movePlayerXLoop\@

.movePlayerXFallthrough\@

ENDM
