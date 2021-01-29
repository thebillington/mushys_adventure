main: link
	@printf "Fixing main.gb...\n"
	rgbfix -v -p 0xFF main.gb
	@rm -f *.o
	@printf "DONE\n\n"

link: assemble
	@printf "Linking main.o...\n"
	rgblink -t -w -v -n main.sym -p 0xFF -o main.gb main.o
	@printf "DONE\n\n"

assemble: main.asm
	@printf "Assembling main.asm...\n"
	rgbasm -v -o main.o main.asm
	@printf "DONE\n\n"

clean:
	@printf "Cleaning work space...\n"
	@rm -f *.gb
	@rm -f *.o
	@rm -f *.sym
	@printf "DONE\n"