
// 2 sprites generated with spritemate on 1/6/2025, 11:37:57 AM
// Byte 64 of each sprite contains multicolor (high nibble) & color (low nibble) information

// LDA #$07 // sprite multicolor 1
// STA $D025
// LDA #$06 // sprite multicolor 2
// STA $D026


// sprite 0 / multicolor / color: $05
sprite_left:
.byte $00,$00,$00,$00,$00,$00,$06,$19
.byte $28,$2a,$aa,$68,$02,$82,$80,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$85

// sprite 1 / multicolor / color: $05
sprite_right:
.byte $00,$00,$00,$00,$00,$00,$28,$64
.byte $90,$29,$aa,$a8,$02,$82,$80,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$85
