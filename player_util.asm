INCLUDE "hardware.inc"

LoadPlayer: MACRO

    ld d, $00

.loadPlayerSpritesLoop\@

    Spr_getY d
    ld e, $70
    ld a, d
    DIVIDE a, $02
    MULT $07
    add e
	ld [hl], a
    
    Spr_getX d
    ld e, $10
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