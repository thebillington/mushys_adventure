SECTION "Tiles", ROM0

TILES:

    ; --------- EMPTY TILE ---------
    DB $00,$00,$00,$00,$00,$00,$00,$00
    DB $00,$00,$00,$00,$00,$00,$00,$00

    ; ------- PLATFORM --------
    DB $FF,$FF,$E7,$7A,$FF,$10,$FB,$46
    DB $F7,$2A,$FF,$20,$F3,$0C,$70,$FF
    
    ; ------- FLOOR --------
	DB $ff,$00,$ff,$00,$ff,$00,$00,$ff
	DB $00,$ff,$00,$ff,$ff,$ff,$ff,$ff

TILESEND: