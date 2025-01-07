ASM=java -jar /home/jan/6502/kickass/KickAss.jar

snek64.prg: src/*.asm
	$(ASM) -o dist/snek64.prg src/main.asm -vicesymbols

emulate:
	x64sc -moncommands dist/main.vs dist/snek64.prg