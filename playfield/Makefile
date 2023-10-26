playfield: playfield.o
	ld -o playfield playfield.o

playfield.o: playfield.asm
	nasm -f elf64 -g -F dwarf playfield.asm -l playfield.lst
