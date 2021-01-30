main: link
	@printf "Fixing main.gb...\n"
	rgbfix -v -m 0x19 -p 0xFF main.gb
	@rm -f *.o
	@printf "DONE\n\n"

link: assemble
	@printf "Linking main.o...\n"
	rgblink -v -w -n main.sym -m main.map -p 0xFF -o main.gb main.o
	# Commenting out until we can fix ROM banking for gbt_player (not my job lol)
	#rgblink -v -w -n main.sym -m main.map -p 0xFF -o main.gb main.o gbt_player.o gbt_player_bank1.o song.o
	@printf "DONE\n\n"

assemble: main.asm
	@printf "Assembling main.asm gbt_player.asm gbt_player_bank1.asm song.asm...\n"
	rgbasm -v -o main.o main.asm
	#rgbasm -v -o gbt_player.o gbt_player.asm
	#rgbasm -v -o gbt_player_bank1.o gbt_player_bank1.asm
	rgbasm -v -o song.o song.asm
	@printf "DONE\n\n"

clean:
	@printf "Cleaning work space...\n"
	@rm -f *.gb
	@rm -f *.o
	@rm -f *.sym
	@rm -f *.map
	@printf "DONE\n"