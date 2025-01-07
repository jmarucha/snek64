#importonce
.const screen_end = screen + 1000
.segment Default
clear_screen:
    lda #<screen
    sta addr
    lda #>screen
    sta addr+1

    lda #1
    ldx #MAP_EMPTY
    !loop:
        adc #1
        stx addr: screen

        // increment 16-bit
        inc addr
        bne !+
        inc addr+1
    !:

        lda #>screen_end
        cmp addr+1
        bne !loop-
        lda #<screen_end
        cmp addr
        bne !loop-
    rts

// A -> screen(X,Y)
put_char:
    pha
    lda rows_lo, y
    sta pixel_dest
    lda rows_hi, y
    sta pixel_dest+1
    pla
    sta pixel_dest: $FFFF,x
    rts
// A-> color(x,y)
put_color:
    pha
    lda crows_lo, y
    sta color_dest
    lda crows_hi, y
    sta color_dest+1
    pla
    sta color_dest: $FFFF,x
    rts

// screen(X,Y) -> A
get_char:
    lda rows_lo, y
    sta pixel_dest2
    lda rows_hi, y
    sta pixel_dest2+1
    lda pixel_dest2: $FFFF,x
    rts
// A-> color(x,y)
get_color:
    lda crows_lo, y
    sta color_dest2
    lda crows_hi, y
    sta color_dest2+1
    lda color_dest2: $FFFF,x
    rts



rows_lo: .fill 25, <(screen_pos(0,i))
rows_hi: .fill 25, >(screen_pos(0,i))

crows_lo: .fill 25, <(color_pos(0,i))
crows_hi: .fill 25, >(color_pos(0,i))

.macro put_str(str_ptr, pos_x, pos_y) {
    ldx #0
loop:
    lda str_ptr, x
    beq end
    sta screen_pos(pos_x, pos_y), x
    inx
    jmp loop
end:
}

.macro put_str_col(str_ptr, pos_x, pos_y, col) {
    ldx #0
loop:
    lda str_ptr, x
    beq end
    sta screen_pos(pos_x, pos_y), x
    lda #col
    sta color_pos(pos_x, pos_y), x
    inx
    jmp loop
end:
}

.macro draw_border(x1,x2,y1,y2) {
        
    .const border_left_top = $70
    .const border_right_top = $6E
    .const border_left_bottom = $6D
    .const border_right_bottom = $7D

    .const border_top = $43
    .const border_left = $5d

        lda #border_top
        ldx #(x2-x1-1)
    !:
        dex
        sta screen_pos(x1+1, y1), x
        bne !-

        lda #border_top
        ldx #(x2-x1-1)
    !:
        dex
        sta screen_pos(x1+1, y2),x
        bne !-

        lda #border_left
        .for(var i=y1+1;i<y2;i++) {
            sta screen_pos(x1,i)
            sta screen_pos(x2,i)
        }

        lda #border_left_top
        sta screen_pos(x1,y1)
        lda #border_right_top
        sta screen_pos(x2,y1)
        lda #border_left_bottom
        sta screen_pos(x1,y2)
        lda #border_right_bottom
        sta screen_pos(x2,y2)
}
.macro color_border(color, x1,x2,y1,y2) {

        lda #color
        ldx #(x2-x1-1)
    !:
        dex
        sta color_pos(x1+1, y1), x
        bne !-
        ldx #(x2-x1-1)
    !:
        dex
        sta color_pos(x1+1, y2),x
        bne !-
        .for(var i=y1+1;i<y2;i++) {
            sta color_pos(x1,i)
            sta color_pos(x2,i)
        }
        sta color_pos(x1,y1)
        sta color_pos(x2,y1)
        sta color_pos(x1,y2)
        sta color_pos(x2,y2)
}

.macro clean_rect(x1, x2, y1, y2) {
    lda #' '
    .for (var i = y1; i < y2+1; i++) {
        ldx #(x2-x1+1)
    !:
        dex
        sta screen_pos(x1, i), x
        bne !-
    }
}
.macro color_rect(x1, x2, y1, y2, col) {
    lda #col
    .for (var i = y1; i < y2+1; i++) {
        ldx #(x2-x1+1)
    !:
        dex
        sta color_pos(x1, i), x
        bne !-
    }
}