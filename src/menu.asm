menu_init:
    set_bg(BLACK)
    set_bor(BLACK)

    // setup sprites
    lda #$0d // sprite multicolor 1
    sta $D025
    lda #$06 // sprite multicolor 2
    sta $D026

    lda #offset_sprite_addr(sprite_left)
    sta VIC_SPRITE_PTR(0)
    lda #offset_sprite_addr(sprite_right)
    sta VIC_SPRITE_PTR(1)

    lda #(%00000011)
    sta VIC_SPRITE_ENABLE
    sta VIC_SPRTIE_MULTICOLOR

    lda #(%00000010)
    sta VIC_SPRITE_X_HIGH

    lda #$A6
    sta VIC_SPRITE_POS(0).x
    lda #$A6+15*8
    sta VIC_SPRITE_POS(1).x

    lda #GREEN
    sta VIC_SPRITE_COLOR(0)
    sta VIC_SPRITE_COLOR(1)



    ldx #200
!loop:
    .for (var i=0; i<3; i++) { // only load upper half of bitmap
        lda colorRam+i*200-1,x
        sta $d800+i*200-1,x
    }
    dex
    bne !loop-

    clean_rect(0,39, 15,24)
    put_str(start_game_s, 21, 17)
    put_str(difficulty_s, 21, 19)
    put_str(difficulty_mid_s, 23, 20)

    rts

selected_item: .byte 0

menu_loop:
    lda selected_item
    bne !+
        lda #$BA
        sta VIC_SPRITE_POS(0).y
        sta VIC_SPRITE_POS(1).y

    // this is horrible
        lda JOYSTICK2
        and #FIRE
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #FIRE
        beq !not_released-
        rts // start game
        !not_pressed:

        lda JOYSTICK2
        and #UP
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #UP
        beq !not_released-
        lda #1
        sta selected_item
        !not_pressed:

        lda JOYSTICK2
        and #DOWN
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #DOWN
        beq !not_released-
        lda #1
        sta selected_item
        !not_pressed:
        jmp menu_loop
    !:
        lda #$CA
        sta VIC_SPRITE_POS(0).y
        sta VIC_SPRITE_POS(1).y


        lda JOYSTICK2
        and #UP
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #UP
        beq !not_released-
        lda #0
        sta selected_item
        !not_pressed:

        lda JOYSTICK2
        and #DOWN
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #DOWN
        beq !not_released-
        lda #0
        sta selected_item
        !not_pressed:

        lda JOYSTICK2
        and #LEFT
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #LEFT
        beq !not_released-
        jsr dec_diff
        !not_pressed:

        lda JOYSTICK2
        and #RIGHT
        bne !not_pressed+
        !not_released:
        lda JOYSTICK2
        and #RIGHT
        beq !not_released-
        jsr inc_diff
        !not_pressed:
        jmp menu_loop

    rts

diff_color: .byte CYAN, GREEN, ORANGE, RED
diff_value: .byte 5, 3, 2, 1
diff_labels: .byte <difficulty_low_s, <difficulty_mid_s, <difficulty_high_s, <difficulty_vhigh_s

diff_setting: .byte 1

inc_diff:
    ldy diff_setting
    cpy #3
    beq !skip+
    iny
    !skip:
    jmp select_diff

dec_diff:
    ldy diff_setting
    cpy #0
    beq !skip+
    dey
    !skip:
    jmp select_diff



select_diff: // diff in y
    sty diff_setting
    lda #>difficulty_low_s
    sta sting_orig+1
    lda diff_labels, y
    sta sting_orig
    ldx #0
loop:
    lda sting_orig: $FFFF, x
    beq end
    sta screen_pos(23, 20), x
    inx
    jmp loop
end:
    lda diff_color, y
    sta VIC_SPRITE_COLOR(0)
    sta VIC_SPRITE_COLOR(1)

    lda diff_value, y
    sta difficulty
    rts