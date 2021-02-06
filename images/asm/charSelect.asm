; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: charSelect.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

charSelect_tile_map_size EQU $0400
charSelect_tile_map_width EQU $20
charSelect_tile_map_height EQU $20

charSelect_tile_data_size EQU $0580
charSelect_tile_count EQU $58

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

mushycharacterselect_map_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $01,$02,$03,$04,$05,$06,$07,$08,$00,$09,$0A,$0B,$0C,$0D,$0E,$0F
DB $10,$11,$12,$13,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $14,$15,$16,$17,$18,$19,$1A,$1B,$00,$1C,$1D,$1E,$1F,$20,$21,$22
DB $23,$24,$25,$26,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$27,$28,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$2A,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$2B,$2C,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$2D,$2E,$2E,$2F,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$30,$31,$32,$33,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$30,$34,$35,$33,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$36,$37,$38,$00,$39,$3A,$3B,$3C,$3C,$3D,$3A,$3A,$00,$3E
DB $3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$40,$41,$42,$00,$43,$44,$3C,$3C,$3C,$3C,$45,$46,$00,$47
DB $48,$49,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$4A,$4B,$4C,$00,$4D,$4E,$3C,$3C,$3C,$3C,$4F,$50,$00,$51
DB $52,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$53,$54,$55,$00,$56,$57,$57,$57,$57,$57,$57,$57,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
mushycharacterselect_map_data_end:

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

mushycharacterselect_tile_data:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $01,$01,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01,$01,$00,$00
DB $F0,$F0,$F8,$F8,$80,$00,$00,$00,$80,$00,$F0,$F0,$F8,$F8,$18,$18
DB $FE,$FE,$FE,$FE,$FE,$C0,$C0,$C0,$C0,$C0,$F8,$F0,$F8,$F0,$C0,$C0
DB $70,$20,$70,$20,$70,$20,$70,$20,$70,$20,$70,$20,$70,$20,$70,$20
DB $7F,$3F,$7F,$3F,$7F,$30,$70,$30,$70,$30,$7C,$3C,$7C,$3C,$70,$30
DB $8F,$8F,$8F,$9F,$8C,$18,$0C,$18,$0C,$18,$0C,$18,$0C,$18,$0C,$18
DB $C7,$87,$E7,$C7,$06,$01,$01,$00,$01,$00,$01,$00,$01,$00,$01,$00
DB $F0,$F0,$F0,$F0,$B0,$C0,$80,$C0,$80,$C0,$80,$C0,$80,$C0,$80,$C0
DB $7C,$7C,$FE,$FE,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
DB $71,$23,$71,$23,$71,$23,$71,$23,$71,$23,$7F,$3F,$7F,$3F,$73,$23
DB $87,$0F,$8F,$1F,$9E,$19,$99,$18,$99,$18,$99,$18,$99,$18,$98,$1F
DB $8F,$07,$87,$CF,$C7,$CE,$C6,$CC,$C6,$CC,$C6,$CC,$C6,$CF,$C7,$CF
DB $C0,$C1,$F1,$E3,$F3,$63,$33,$63,$33,$63,$33,$63,$43,$C3,$E3,$C3
DB $E0,$F0,$F1,$F8,$F9,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$F8
DB $7C,$78,$FE,$FC,$80,$C0,$80,$C0,$80,$C0,$80,$C0,$80,$C0,$80,$C0
DB $3F,$7F,$7F,$7F,$6F,$1C,$1C,$0C,$1C,$0C,$1C,$0C,$1C,$0C,$1C,$0C
DB $1F,$1F,$1F,$1F,$1F,$18,$18,$18,$18,$18,$1F,$1F,$1F,$1F,$18,$18
DB $CF,$C7,$CF,$C7,$CF,$06,$0C,$06,$0C,$06,$0C,$06,$0E,$07,$0F,$07
DB $C0,$C0,$F0,$E0,$E0,$70,$60,$30,$60,$30,$60,$30,$40,$C0,$E0,$C0
DB $00,$00,$00,$00,$03,$03,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00
DB $18,$18,$18,$18,$F8,$F8,$F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00
DB $C0,$C0,$C0,$C0,$FE,$FE,$FE,$FE,$00,$00,$00,$00,$00,$00,$00,$00
DB $70,$20,$70,$20,$7E,$3E,$7E,$3E,$00,$00,$00,$00,$00,$00,$00,$00
DB $70,$30,$70,$30,$7F,$3F,$7F,$3F,$00,$00,$00,$00,$00,$00,$00,$00
DB $0C,$18,$0C,$18,$8F,$9F,$8F,$87,$00,$00,$00,$00,$00,$00,$00,$00
DB $01,$00,$01,$00,$E1,$C0,$C1,$80,$00,$00,$00,$00,$00,$00,$00,$00
DB $80,$C0,$80,$C0,$80,$C0,$80,$C0,$00,$00,$00,$00,$00,$00,$00,$00
DB $C0,$C0,$C0,$C0,$FE,$FE,$7C,$7C,$00,$00,$00,$00,$00,$00,$00,$00
DB $71,$23,$71,$23,$71,$23,$71,$23,$00,$00,$00,$00,$00,$00,$00,$00
DB $9F,$1F,$9E,$19,$99,$18,$99,$18,$00,$00,$00,$00,$00,$00,$00,$00
DB $C5,$CE,$C6,$CC,$C6,$CC,$C6,$CC,$00,$00,$00,$00,$00,$00,$00,$00
DB $B3,$63,$33,$63,$33,$63,$33,$63,$00,$00,$00,$00,$00,$00,$00,$00
DB $F9,$F8,$59,$B8,$19,$18,$18,$18,$00,$00,$00,$00,$00,$00,$00,$00
DB $80,$C0,$80,$C0,$FE,$FC,$7C,$78,$00,$00,$00,$00,$00,$00,$00,$00
DB $1C,$0C,$1C,$0C,$1C,$0C,$1C,$0C,$00,$00,$00,$00,$00,$00,$00,$00
DB $18,$18,$18,$18,$1F,$1F,$1F,$1F,$00,$00,$00,$00,$00,$00,$00,$00
DB $0D,$06,$0C,$06,$CC,$C6,$CC,$C6,$00,$00,$00,$00,$00,$00,$00,$00
DB $A0,$70,$60,$30,$60,$30,$60,$30,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$07,$06,$07,$04,$0F,$08
DB $00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0,$E0,$60,$E0,$20,$F0,$10
DB $0F,$08,$1F,$10,$1F,$17,$0B,$0B,$03,$03,$03,$03,$03,$03,$03,$03
DB $F0,$10,$F8,$08,$78,$E8,$50,$D0,$40,$C0,$40,$C0,$40,$C0,$40,$C0
DB $02,$03,$02,$03,$06,$07,$0C,$0F,$00,$00,$00,$00,$00,$00,$00,$00
DB $40,$C0,$40,$C0,$30,$F0,$18,$F8,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$E0
DB $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FC,$FC,$F8,$F8,$F8,$F8
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$3F,$3F,$1F,$1F,$0F,$0F,$0F,$0F
DB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0
DB $F8,$F8,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $0F,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$00,$00,$1F,$00,$3F,$1F,$3F,$1F,$30,$1F,$E0,$FF,$E0,$FF
DB $00,$00,$00,$00,$FF,$00,$FF,$FF,$FF,$FF,$00,$FF,$00,$FF,$00,$FF
DB $00,$00,$00,$00,$80,$00,$80,$80,$80,$80,$00,$80,$70,$E0,$70,$E0
DB $00,$00,$00,$00,$00,$00,$00,$00,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
DB $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $03,$03,$03,$03,$03,$03,$03,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FC,$FC
DB $E0,$FF,$07,$F8,$07,$F8,$1F,$E0,$3F,$C0,$FF,$00,$00,$00,$00,$00
DB $00,$FF,$FC,$03,$FC,$03,$FF,$00,$FF,$00,$FF,$00,$E4,$78,$E4,$78
DB $60,$F0,$1E,$FE,$1E,$FE,$80,$7E,$80,$7E,$FE,$00,$00,$00,$00,$00
DB $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$7E,$7C,$7C,$7C,$7C,$7C,$7C
DB $FF,$FF,$FF,$FF,$FF,$FF,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
DB $FF,$FF,$FF,$FF,$FF,$FF,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC,$FC
DB $FF,$FF,$FF,$FF,$FF,$FF,$7F,$7F,$3F,$3F,$1F,$1F,$1F,$1F,$1F,$1F
DB $07,$07,$0F,$0F,$1F,$1B,$3F,$3F,$3F,$2D,$3F,$3F,$18,$18,$00,$00
DB $C2,$FE,$D1,$6F,$C1,$FF,$85,$FB,$A2,$DD,$08,$FF,$C7,$F7,$C0,$F0
DB $00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$1F,$03,$3F,$1F
DB $E4,$78,$E4,$78,$E4,$78,$E4,$78,$E0,$FF,$E0,$FF,$E0,$FF,$E0,$FF
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$60,$80,$30,$E0
DB $7E,$7E,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
DB $1F,$1F,$1F,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $FC,$FC,$FC,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $3F,$3F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$03,$03,$07,$07,$00,$00
DB $C0,$F0,$C0,$F0,$C0,$F0,$C0,$F0,$80,$F8,$A0,$DE,$30,$CE,$00,$00
DB $3F,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $E0,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $10,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $7F,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
mushycharacterselect_tile_data_end: