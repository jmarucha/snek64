
start_data_ptr_bg: .byte 0
start_data_ptr_end: .byte 0
.align $100

// use x, y for coords
add_snake_food:
    lda #MAP_FULL_SNAKE
    bne !+
add_snake:
    lda #MAP_SNAKE
!:
    jsr put_char
    lda current_color
    jsr put_color
    txa
    ldx start_data_ptr_end
    sta snake_data_x, x
    tya
    sta snake_data_y, x
    tax
    inc start_data_ptr_end
    rts

rem_snake:
    ldx start_data_ptr_bg
    ldy snake_data_y, x
    lda snake_data_x, x
    tax
    jsr get_char
    cmp #MAP_FULL_SNAKE
    beq !+ // if regular snake
        lda #MAP_EMPTY
        jsr put_char
        inc start_data_ptr_bg
        rts
    !: // if full snake
        dec mult
        lda #MAP_SNAKE
        jsr put_char
        rts

get_head_pos:
    ldx start_data_ptr_end
    dex
    ldy snake_data_y, x
    lda snake_data_x, x 
    tax
    rts 

create_food:
    jsr random_x
    tax
    jsr random_y
    tay
    jsr get_char
    cmp #MAP_EMPTY
    bne create_food
    lda #MAP_FOOD
    jsr put_char
    jsr random_color
    jsr put_color
    rts

random_x:
rand(1,39)

random_y:
rand(2,23)

random_color:
rand(1, 15)
