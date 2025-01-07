init:
    ldx #$FF
    txs
    // reprogram interrupts
    sei
    change_irq_routine(irq_reprogram_vic_and_go)
    cli

    jsr clear_screen
    color_rect(0, 39, 0, 24, LIGHT_BLUE)

    set_bg(BLACK)
    set_bor(BLACK)

    jsr init_rng

    // reset game state
    lda #0
    sta points
    sta direction
    sta start_data_ptr_bg
    sta start_data_ptr_end

    sta VIC_SPRITE_ENABLE

    lda #1
    sta mult
    lda #%00001000
    sta previouis_direction

    put_str(title_s, 1, 0)
    put_str(score_s, 31, 0)

    // pointers for points display
    setup_base10_disp(points, 36, 0)

    draw_border(0,39,1,24)

    // init snek
    .for(var i = 0; i < 5; i++) {
        add_snake(5+i, 10)
    }

    // init food
    jsr create_food

    lda #0
    sta counter
    jmp game_loop




.macro add_snake(pos_x, pos_y) {
    ldx #pos_x
    ldy #pos_y
    jsr add_snake
}

init_rng:
    lda #$FF  // maximum frequency value
    sta $D40E // voice 3 frequency low byte
    sta $D40F // voice 3 frequency high byte
    lda #$80  // noise waveform, gate bit off
    sta $D412 // voice 3 control register
rts

.macro rand(min,max) {
clc
start:
    lda $D41B
    cmp #max-min
    bcs start
    adc #min
    rts
}

#import "strings.asm"