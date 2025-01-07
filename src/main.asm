#import "consts.asm"

.var picture = LoadBinary("gfx/art.kla", BF_KOALA)
.print "Koala format="+BF_KOALA
BasicUpstart2(main)

main:
    // stack init
    ldx #$FF
    txs

    jsr setup_irq

    jsr menu_init
    jsr menu_loop

    jmp init // goes to game loop

#import "interrupts.asm"
#import "init.asm"
#import "game_loop.asm"
#import "base_10.asm"
#import "gfx.asm"
#import "menu.asm"
#import "snek.asm"

*=$1900 "snake state"
snake_data_x: .fill $100,0
snake_data_y: .fill $100,0

*=$1600 "color ram"
colorRam:  .fill $240, picture.getColorRam(i)
*=$2000 "bitmap rom"
.fill 4800, picture.getBitmap(i) // picture.getBitmapSize()
*=$3400 "screen ram"
.fill picture.getScreenRamSize(), picture.getScreenRam(i)

*=$3300 "sprite"
#import "gfx/menu_sprite.asm"