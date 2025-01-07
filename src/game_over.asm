
game_over:
    put_str(snek_is_dead_s, 5, 0)

    // put graphics
    draw_border(10, 29, 11, 16)
    color_border(RED, 10, 29, 11, 16)
    clean_rect(11, 28, 12, 15)
    color_rect(11, 28, 12, 15, GREY)

    put_str(game_over_s, 15, 12)
    put_str(score_s, 13, 14)
    put_str(hi_score_s, 13, 15)

    lda #0
    sta hi_score_bet
    // investigate high_score
    sec
    lda hi_score
    cmp points
    bcs !+ //if points > hi_score
        lda #1
        sta hi_score_bet

        lda points
        sta hi_score
        color_rect(25, 26, 14, 15, RED)
    !:
    setup_base10_disp(points, 24, 14)
    jsr display_number

    setup_base10_disp(hi_score, 24, 15)
    jsr display_number

    lda #0
    sta counter
!end_loop:
    sec
    lda counter
    sbc #10
    bcs !end_animation+
        sta counter
        lda hi_score_bet
        beq !end_animation+

        lda score_color
        cmp #RED
        beq !+
            lda #RED
            sta score_color
            bne !++  // bra 
        !:
            lda #GREY
            sta score_color
        !:
        sta color_pos(25, 14)
        sta color_pos(26, 14)
        sta color_pos(25, 15)
        sta color_pos(26, 15)
    !end_animation:


    lda JOYSTICK2
    and #FIRE
    bne !end_loop-
    jmp init

score_color: .byte  RED