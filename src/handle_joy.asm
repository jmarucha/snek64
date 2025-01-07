.const JOYSTICK2 = $DC00
.const UP    = %00000001
.const DOWN  = %00000010
.const LEFT  = %00000100
.const RIGHT = %00001000
.const FIRE  = %00010000

handle_joystic_input:
    lda JOYSTICK2
    and #UP
    bne !+
    lda previouis_direction
    cmp #DOWN
    beq !+
    lda #UP
    sta direction
    rts
    !:

    lda JOYSTICK2
    and #DOWN
    bne !+
    lda previouis_direction
    cmp #UP
    beq !+
    lda #DOWN
    sta direction
    rts
    !:

    lda JOYSTICK2
    and #LEFT
    bne !+
    lda previouis_direction
    cmp #RIGHT
    beq !+
    lda #LEFT
    sta direction
    rts
    !:

    lda JOYSTICK2
    and #RIGHT
    bne !+
    lda previouis_direction
    cmp #LEFT
    beq !+
    lda #RIGHT
    sta direction
    !:
rts
