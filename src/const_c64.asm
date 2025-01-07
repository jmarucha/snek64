.const border_color = $D020
.const bgcolor = $D021
.const screen = $0400


.macro set_bg(col) {
    lda #col
    sta bgcolor
}
.macro set_bor(col) {
    lda #col
    sta border_color
}

.function screen_pos(x,y) {
    .return screen + 40*y + x
}

.const color = $D800
.function color_pos(x,y) {
    .return color + 40*y + x
}

.label VIC_MEMORY_PTR = $D018
.label VIC_SCR1 = $D011
.label VIC_SCR2 = $D016



.label VIC_SPRITE_ENABLE = $D015
.label VIC_SPRTIE_MULTICOLOR = $D01C
.label VIC_SPRITE_X_HIGH = $D010


.function VIC_SPRITE_PTR(i) {
    .return $07F8+i
}
.function VIC_SPRITE_COLOR(i) {
    .return $D027+i
}

.struct Coord {x, y}

.function VIC_SPRITE_POS(i) {
    .return Coord($D000+2*i, $D000+2*i+1)
}

.function offset_sprite_addr(a) {
    .return <(a>>6) 
}