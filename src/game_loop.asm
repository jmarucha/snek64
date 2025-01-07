#import "handle_joy.asm"
#import "game_over.asm"

direction: .byte 0
previouis_direction: .byte 0  // avoid deadly turnarounds

current_color: .byte LIGHT_BLUE  // updated when eating food
points: .byte 0
hi_score: .byte 0
hi_score_bet: .byte 0
difficulty: .byte 3
mult: .byte 1


game_loop:
    jsr handle_joystic_input
    jsr display_number  // draw points

    jsr display_mult

    sec
    lda counter
    sbc difficulty
    bpl !+
        sta counter
        jsr handle_move
    !:

    jmp game_loop


handle_move:
    lda direction
    beq !skip+
        sta previouis_direction
    !skip:
    jsr get_head_pos

    // compute new position
    lda direction
    bne !+
        rts
    !:
    cmp #UP
    bne !+
        dey
    !:
    cmp #LEFT
    bne !+
        dex
    !:
    cmp #RIGHT
    bne !+
        inx
    !:
    cmp #DOWN
    bne !+
        iny
    !:

    // handle objects at new position
    jsr get_char;
    pha
    cmp #MAP_FOOD
    bne !else+  // Eat food
        jsr get_color
        sta current_color
        pla // discard
        jsr add_snake_food
        jsr rem_snake
        clc
        lda points
        adc mult
        sta points
        jsr inc_mult
        jmp create_food
    !else:  // just move
        pla
        cmp #MAP_EMPTY
        beq !+
            jmp game_over
        !:
        jsr add_snake
        jmp rem_snake

inc_mult:
    // handle multiplyer
    inc mult
    lda #10
    cmp mult
    bne !+
    lda #9
    sta mult
    !:
    rts

display_mult:
    clc
    lda mult
    ldx #'x'
    adc #$30 // screencode is num+$30
    !end:
    stx screen_pos(37,24)
    sta screen_pos(38,24)

    // colors
    ldx mult
    lda mult_colors,x
    sta color_pos(37,24)
    sta color_pos(38,24)

    rts

mult_colors: .byte WHITE, LIGHT_BLUE, LIGHT_BLUE, LIGHT_BLUE, LIGHT_GREEN, YELLOW, YELLOW, YELLOW, YELLOW, RED
