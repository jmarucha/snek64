
setup_irq:
    sei
    lda #%01111111
    sta $DC0D

    and $D011
    sta $D011

    sta $DC0D
    sta $DD0D

    lda line
    sta $D012

    lda #<irq
    sta $0314
    lda #>irq
    sta $0315

    lda #%00000001
    sta $D01A
    cli 
    rts

.macro change_irq_routine(irq_func) {
    lda #<irq_func
    sta $0314
    lda #>irq_func
    sta $0315
}


counter: .byte 0

.const interrupt_line = 166
line: .byte interrupt_line


// main menu
// switches to bitmap at line 0
// switches to text at line 170
irq: 
    asl $D019
    lda $D012
    cmp #interrupt_line
    bne !else+
        lda #0
        sta $D012

        //.fill 30, NOP
        // text mode from line 170 to 0
        lda #%00010100
        sta VIC_MEMORY_PTR

        lda #%00011011
        sta VIC_SCR1
        lda #%00001000
        sta VIC_SCR2

        jmp $EA31
    !else:
        lda #interrupt_line
        sta $D012

        // gft mode from line 0 to 170
        lda #%11011000
        sta VIC_MEMORY_PTR
        lda #%00111000
        sta VIC_SCR1
        lda #%11011000
        sta VIC_SCR2
        
        jmp $EA31

irq_reprogram_vic_and_go:
    lda #0
    sta $D012
    //back to text mode
    lda #%00010100
    sta VIC_MEMORY_PTR

    lda #%00011011
    sta VIC_SCR1
    lda #%00001000
    sta VIC_SCR2
    change_irq_routine(irq_game_loop)
    jmp $EA31

irq_game_loop:
    asl $D019
    inc counter
    jmp $EA31